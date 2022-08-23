#!/bin/bash

#using shared library so we need this
export LD_LIBRARY_PATH=./

#copying packets to a variable and removing unwanted chars
packets=$(cat /dev/stdin | sed -e 's/#.*//' | tr -d ' ')
#parsing rules 
while read rule; do
	accepted_packets=""
	#cleaning rule from unwanted chars
	clean_rule=$(echo "$rule" | sed '/^[[:blank:]]*#/d;s/#.*//' | sed 's/ //g')
	#skip empty lines
	if [ -z "$rule" ]; then
		continue 
	fi
		
	if [[ "$clean_rule" != "$accepted_packets" ]]; then
	#dividing rule according to fields and placing each string in variable
		sub_rule_src_ip=$(echo $clean_rule | awk -F, '{print $1}')
		sub_rule_src_dst=$(echo $clean_rule | awk -F, '{print $2}')
		sub_rule_src_port=$(echo $clean_rule | awk -F, '{print $3}')
		sub_rule_dst_port=$(echo $clean_rule | awk -F, '{print $4}')
		#parsing packet field by field (the "AND" mentioned in the instructions)
		final_list+=$(echo "$packets" | ./firewall.exe "$sub_rule_src_ip" | \./firewall.exe "$sub_rule_src_dst" | \./firewall.exe "$sub_rule_src_port" | \./firewall.exe "$sub_rule_dst_port" )
		print+="\n"
	fi
done < "$1"
echo -e "$final_list" | sed "s/src-ip/\n&/g" | sed '/^$/d' | sort
