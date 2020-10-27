import os

file1 = open('terr-out', 'r') 
Lines = file1.readlines() 
par ="instance_ip_address"
count = 0
k=[]
# Strips the newline character 
for line in Lines: 
	if par in line:
		k=list(line.split('='))

    

#a="ss=p100"
#k=list(a.split('='))
#print(k[1])
invent='''
[amzl]
x.x.x.x	 ansible_user=ec2-user

[linux:children]
amzl

[linux:vars]
ansible_ssh_private_key_file	= "~/itea-hub.pem"
ansible_ssh_extra_args		= '-o StrictHostKeyChecking=no'
'''

with(open('inventory','w+')) as f:
	f.write(invent.replace('x.x.x.x',trim(k[1]) ))
	f.close()
