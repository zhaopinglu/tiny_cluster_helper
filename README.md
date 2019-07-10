# tiny_cluster_help
Tiny cluster helper: A tiny tool to make it easy to run command over ssh on cluster hosts/vms.

Author: zhaopinglu77(at)gmail.com

# Quick Example:
Execute "w" command on every VMs defined in node group "all"
```
[root@vm1 ~]$ e all w
### Execute command (w) on node (vm0). ###
 19:28:48 up 1 day, 21:13,  2 users,  load average: 0.44, 0.43, 0.60
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    salt             03:23   23:28   1.55s  1.55s -bash
root     :0       :0               Mon03   ?xdm?   8:26m  1.19s /usr/libexec/gnome-session-binary --session gnome-classic
### Execute command (w) on node (vm1). ###
 19:28:48 up 1 day, 21:30,  1 user,  load average: 0.03, 0.13, 0.09
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    salt             19:01    4.00s  0.34s  0.00s ssh -C -o ControlMaster=auto -o ControlPersist=6000s -o ConnectTimeout=4 -o ControlPath=/tmp/ssh_mux_%h_%p_%r vm1 w
### Execute command (w) on node (vm2). ###
 19:28:48 up 2 days, 16:07,  0 users,  load average: 0.03, 0.07, 0.04
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
### Execute command (w) on node (vm3). ###
 19:28:48 up 2 days, 16:07,  0 users,  load average: 0.14, 0.08, 0.02
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
### Execute command (w) on node (vm4). ###
 19:28:48 up 2 days, 16:07,  0 users,  load average: 0.00, 0.02, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
### Execute command (w) on node (vm5). ###
 19:28:48 up 2 days, 16:07,  0 users,  load average: 0.00, 0.03, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
### Execute command (w) on node (vm6). ###
 19:28:48 up 2 days, 16:07,  0 users,  load average: 0.05, 0.02, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
### Execute command (w) on node (vm7). ###
 19:28:48 up 2 days, 16:07,  0 users,  load average: 0.00, 0.01, 0.02
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
```


# Update Logs:
20160701, created

20181102, Modify copy_from function.

20190708, Remove some unrelevant functions. Improve and Simplify the rest.

# How to use:
1. Put this single script in any place. Add your host or vm list the header of this script as below. 
![alt text](/Screenshot/vm_list.png)

## 2. Source this script: 

       ```
       source tiny_cluster_helper.sh
       ```

## 3. Create ssh equivalent, eg: "ssheq all", then input the password. Note: all node should have the same password.

       ```
       ssheq all
       ```

## 4. Enjor the following commands:

   ### Copy file or folder to remote nodes.   
    
       ```
       c all mydata.csv /tmp
       ```
       
   ### Execute command/script on remote nodes
    
       ```
       e all date
       
       ### Execute command (date) on node (vm0). ###
       Tue Jul  9 22:26:47 EDT 2019
       ### Execute command (date) on node (vm1). ###
       Tue Jul  9 22:26:48 EDT 2019
       ### Execute command (date) on node (vm2). ###
       Tue Jul  9 22:26:48 EDT 2019
       ### Execute command (date) on node (vm3). ###
       Tue Jul  9 22:26:48 EDT 2019
       ### Execute command (date) on node (vm4). ###
       Tue Jul  9 22:26:48 EDT 2019
       ### Execute command (date) on node (vm5). ###
       Tue Jul  9 22:26:48 EDT 2019
       ### Execute command (date) on node (vm6). ###
       Tue Jul  9 22:26:48 EDT 2019
       ### Execute command (date) on node (vm7). ###
       Tue Jul  9 22:26:48 EDT 2019

       real	0m0.562s
       user	0m0.038s
       sys	0m0.064s
       ```
       
   ### Execute command/script on remote nodes with tty
       
       ```
       e_tty all hostname
       ```   
    
   ### Execute command/script on remote nodes in parallel

       ```
       e_px all date
       
       ### Execute command (date) on node (vm0) in background. ###
       ### Execute command (date) on node (vm1) in background. ###
       ### Execute command (date) on node (vm2) in background. ###
       ### Execute command (date) on node (vm3) in background. ###
       ### Execute command (date) on node (vm4) in background. ###
       ### Execute command (date) on node (vm5) in background. ###
       ### Execute command (date) on node (vm6) in background. ###
       ### Execute command (date) on node (vm7) in background. ###
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       Tue Jul  9 22:29:07 EDT 2019
       [1]+  Done                    _exec_on $@
       ```   







