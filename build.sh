#!/bin/bash
terraform apply -auto-approve
terraform output > ip.txt
sed -r 's/\s+//g' ip.txt > temp1.txt && sed 's/^/webserver /' temp1.txt > temp2.txt 
sed 's/$/ ansible_user=root/' temp2.txt > invent.txt
rm temp1.txt temp2.txt
ansible-playbook ansible.yml -i invent.txt
