#!/bin/bash
####################################################
##  opstools deploy config file generator script
##      written by wxl
##          on 2018-05-20 13:14
####################################################

stackrc="/home/stack/stackrc"
site_yml="/home/stack/site-vars.yml"

# 1.set undercloud stackrc config
function set_stackrc_config() {
    source $stackrc

    OS_PASSWORD=`echo $OS_PASSWORD`
    OS_AUTH_URL=`echo $OS_AUTH_URL`
    OS_USERNAME=`echo $OS_USERNAME`
    OS_TENANT_NAME=`echo $OS_TENANT_NAME`

    os_username=${OS_USERNAME:-"admin"}
    os_tenant_name=${OS_TENANT_NAME:-"admin"}

    sed -i -r "s!(openstack_auth_url:)[^:]*!\1 $OS_AUTH_URL!" ~/monitor-deploy/uds-prom-config.yml
    sed -i -r "s/(openstack_auth_project_name:)[^:]*/\1 $OS_TENANT_NAME/" ~/monitor-deploy/uds-prom-config.yml
    sed -i -r "s/(openstack_auth_username:)[^:]*/\1 $OS_USERNAME/" ~/monitor-deploy/uds-prom-config.yml
    sed -i -r "s/(openstack_auth_password:)[^:]*/\1 $OS_PASSWORD/" ~/monitor-deploy/uds-prom-config.yml
}

# 2.set ceph keyring config
function set_ceph_key_config() {
    controller_node=`nova  --os-username=$os_username --os-auth-url=$OS_AUTH_URL --os-password=$OS_PASSWORD --os-project-name=$os_tenant_name list| grep controller-0 | awk -F '|' '{print $7}' | cut -d '=' -f 2`
    cephmoniplist=`ssh heat-admin@$controller_node "sudo ceph-conf --lookup mon_host"`
    cephkey=`ssh heat-admin@$controller_node "sudo ceph-authtool -p /etc/ceph/ceph.client.admin.keyring"`
    sed -i -r "s/(ceph_client_key:)[^:]*/\1 $cephkey/" ~/monitor-deploy/uds-prom-config.yml
}

# 3.set etcd_vip config
function set_etcd_vip_config() {
    etcd_vip_origin=`ssh heat-admin@$controller_node "sudo cat /etc/puppet/hieradata/vip_data.json | grep etcd_vip "`
    etcd_vip=`echo $etcd_vip_origin | cut -d '"' -f 4`
    sed -i -r "s/(etcd_vip:)[^:]*/\1 $etcd_vip/" ~/monitor-deploy/uds-prom-config.yml
}

# 4.set hosts file
function set_inventory_config() {
    nova  --os-username=$OS_USERNAME --os-auth-url=$OS_AUTH_URL --os-password=$OS_PASSWORD --os-project-name=$os_tenant_name list | awk -F '|' '{print $3,$7}' | while read line
    do
        if [[ $line =~ "controller" ]];then
           IP=`echo $line | cut -d '=' -f 2`
           sed -i "/base_exporter/a\\$IP ansible_ssh_user=heat-admin node_role=mon" ~/monitor-deploy/uds-prom-inventory.hosts
           sed -i "/ceph_mgr/a\\$IP ansible_ssh_user=heat-admin" ~/monitor-deploy/uds-prom-inventory.hosts
        elif [[ $line =~ "object" ]];then
           IP=`echo $line | cut -d '=' -f 2`
           sed -i "/base_exporter/a\\$IP ansible_ssh_user=heat-admin node_role=rgw" ~/monitor-deploy/uds-prom-inventory.hosts
        elif [[ $line =~ "storage" ]];then
           IP=`echo $line | cut -d '=' -f 2`
           sed -i "/base_exporter/a\\$IP ansible_ssh_user=heat-admin node_role=osd" ~/monitor-deploy/uds-prom-inventory.hosts
           sed -i "/ceph_osd/a\\$IP ansible_ssh_user=heat-admin" ~/monitor-deploy/uds-prom-inventory.hosts
        fi
    done
}

# 5.set hosts file [ceph_mon] section
function set_inventory_mon_config() {
    cephmoniplist=${cephmoniplist//,/ };
    arr=($cephmoniplist)
    for each in ${arr[*]}
    do
        sed -i "/ceph_mon/a\\$each ansible_ssh_user=heat-admin" ~/monitor-deploy/uds-prom-inventory.hosts
    done
}

# 6.set hosts file [base_exporter] seed_node section
function set_inventory_seed_config() {
    sed -i "/base_exporter/a\\$seed_ip ansible_ssh_user=root node_role=prom_server" ~/monitor-deploy/uds-prom-inventory.hosts
    sed -i "/prometheus/a\\$seed_ip ansible_ssh_user=root" ~/monitor-deploy/uds-prom-inventory.hosts
    sed -i "/alertmanager/a\\$seed_ip ansible_ssh_user=root" ~/monitor-deploy/uds-prom-inventory.hosts
    sed -i "/blackbox_exporter/a\\$seed_ip ansible_ssh_user=root" ~/monitor-deploy/uds-prom-inventory.hosts
}

# 7.set hosts file [base_exporter] undercloud section
function set_inventory_undercloud_config() {
    sed -i "/base_exporter/a\\$undercloud_ip ansible_ssh_user=root node_role=undercloud" ~/monitor-deploy/uds-prom-inventory.hosts
}


if [ -s $stackrc ];then
    mkdir -p ~/monitor-deploy
    cp /usr/share/prom-deploy/clustername-prom-config-example.yml ~/monitor-deploy/uds-prom-config.yml
    cp /usr/share/prom-deploy/clustername-prom-inventory-example.hosts ~/monitor-deploy/uds-prom-inventory.hosts

    set_stackrc_config
    set_ceph_key_config
    set_etcd_vip_config
    set_inventory_config
    set_inventory_mon_config

    echo "set uds-prom-config.yml complete !"
else
    echo "error,no $stackrc file !"
    exit 1
fi

if [ -s $site_yml ];then
    seed_ip=`grep seed_node_ip $site_yml | cut -d ' ' -f 2`
    undercloud_ip=`grep undercloud_ip $site_yml | cut -d ' ' -f 2`

    set_inventory_seed_config
    set_inventory_undercloud_config

    echo "set uds-prom-inventory.hosts complete !"
else
    echo "error,no $site_yml file"
    exit 1
fi
