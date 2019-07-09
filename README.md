# tiny_cluster_help
Tiny cluster helper: A tiny tool to make it easy to run command over ssh on cluster hosts/vms.
Author: zhaopinglu77@gmail.com


# How to use:
1. Put this single script in any place. Add your host or vm list the header of this script as below. 

2. Source this script, like: "source tiny_cluster_helper.sh"

3. Create ssh equivalent, eg: "ssheq all", then input the password. Note: all node should have the same password.

4. Enjor the following commands:
       c: copy file or folder to remote nodes.         eg: c all mydata.csv /tmp
       e: execute command/script on remote nodes.      eg: e all hostname
       e_tty: same as command "e" but with tty. 
       e_px: same as command "e" but will execute command in parallel. 

![alt text](/Screenshot/vm_list.png)





# Update Logs:
20160701, created
20181102, Modify copy_from function.
20190708, Remove some unrelevant functions. Improve and Simplify the rest.
