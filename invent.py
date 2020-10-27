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

    

param='export instance_ip_address="x.x.x.x"'
with(open('envparam1','w+')) as f:
	f.write(param.replace('x.x.x.x',k[1].strip() ))
	f.close()
pt='"'	
with(open('envparam2','w+')) as f:
	f.write(pt+k[1].strip()+pt )
	f.close()	



invent='''
[amzl]
x.x.x.x	 ansible_user=ec2-user

[linux:children]
amzl

[linux:vars]
ansible_ssh_private_key_file	= "~/.ssh/id_rsa"
ansible_ssh_extra_args		= '-o StrictHostKeyChecking=no'
'''

with(open('inventory','w+')) as f:
	f.write(invent.replace('x.x.x.x',k[1].strip() ))
	f.close()

