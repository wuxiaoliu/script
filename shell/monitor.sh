#!/bin/bash

function send_data(){
        ts=`date +%s`;
        metric=$1;
        endpoint=`hostname`;
        value=$2;
        tags=$3
        curl -X POST -d "[{\"metric\": \"$metric\", \"endpoint\": \"$endpoint\", \"timestamp\": $ts,\"step\": 60,\"value\": $value,\"counterType\": \"GAUGE\",\"tags\": \"$tags\"}]" http://127.0.0.1:1988/v1/push}

# monitor outgoing connection number
function vm_out_connection_report(){
	adm conn device|awk '{print $2,$4}'|egrep -v '^\s*$|Tap_mac'|while read mac connections;do
		send_data vm_out_connection $connections vm_mac=$mac
	done
}

# get adm basic status
function get_basic_status(){
        adm stats show basic > /tmp/basic_status1
        sleep 10
        adm stats show basic > /tmp/basic_status2
}

# monitor outgoing pps
function vm_out_pps_report(){
        cat /tmp/basic_status1 |awk '{if($6=="l2")print $4,$12}' | grep -v -i none >/tmp/pps1
        cat /tmp/basic_status2 |awk '{if($6=="l2")print $4,$12}' | grep -v -i none >/tmp/pps2
        awk 'NR==FNR{a[$1]=$2;next}{print $1,$2,a[$1]}' /tmp/pps1 /tmp/pps2 |while read mac pps2 pps1;do
                send_data vm_out_pps $((($pps2-$pps1)/10)) vm_mac=$mac
        done
}

# monitor incomming pps
function vm_in_pps_report(){
        cat /tmp/basic_status1 |awk '{if($6=="l2")print $4,$8}' | grep -v -i none >/tmp/pps3
        cat /tmp/basic_status2 |awk '{if($6=="l2")print $4,$8}' | grep -v -i none >/tmp/pps4
        awk 'NR==FNR{a[$1]=$2;next}{print $1,$2,a[$1]}' /tmp/pps3 /tmp/pps4 |while read mac pps4 pps3;do
                send_data vm_in_pps $((($pps4-$pps3)/10)) vm_mac=$mac
        done
}

# monitor free memory
function mem_free_size_report(){
	mem_free_size=$(adm stats show memory|awk 'NR==4{free_size=$6}END{print (free_size/1024)/1024}')
	send_data mem_free_size $mem_free_size
}
# monitor vpc connection number
function domain_connection_report(){
	adm conn sumary|egrep -v "Domain|ALL"|grep "|"|awk -F '|' '{print $2,$(NF-1)}'|while read domain num;do
		send_data domain_connection $num domain=$domain
	done
}
# monitor vpc total connection number
function all_domain_connection_report(){
	num=$(adm conn sumary|egrep "ALL"|awk -F '|' '{print $(NF-1)}')
	send_data all_domain_connection $num
}

vm_out_connection_report
mem_free_size_report
domain_connection_report
all_domain_connection_report

get_basic_status
vm_out_pps_report
vm_in_pps_report
vm_out_bytes_report
vm_in_bytes_report
