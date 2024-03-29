# Tiny cluster helper
A tiny tool to make it much easier to create ssh-equivalent then run command over ssh on cluster hosts/vms.

Author: zhaopinglu77(at)gmail.com

# Quick Example:
Execute "w" command on every VMs defined in node group "all"

    [root@vm0 ~]$ e all w
    ### Execute command (w) on node (vm0). ###
     22:37:35 up 2 days, 22 min,  3 users,  load average: 0.16, 0.18, 0.19
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/1    salt             22:23   14:06   0.09s  0.09s -bash
    root     pts/0    salt             22:22    2.00s  0.32s  0.32s -bash
    root     :0       :0               Mon03   ?xdm?   9:02m  1.24s /usr/libexec/gnome-session-binary --session gnome-classic
    ### Execute command (w) on node (vm1). ###
     22:37:35 up 2 days, 39 min,  0 users,  load average: 0.08, 0.07, 0.05
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    ### Execute command (w) on node (vm2). ###
     22:37:35 up 2 days, 19:16,  0 users,  load average: 0.16, 0.07, 0.04
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    ### Execute command (w) on node (vm3). ###
     22:37:35 up 2 days, 19:16,  0 users,  load average: 0.00, 0.03, 0.02
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    ### Execute command (w) on node (vm4). ###
     22:37:35 up 2 days, 19:16,  0 users,  load average: 0.00, 0.00, 0.00
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    ### Execute command (w) on node (vm5). ###
     22:37:36 up 2 days, 19:16,  0 users,  load average: 0.06, 0.07, 0.02
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    ### Execute command (w) on node (vm6). ###
     22:37:36 up 2 days, 19:16,  0 users,  load average: 0.16, 0.05, 0.01
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    ### Execute command (w) on node (vm7). ###
     22:37:36 up 2 days, 19:16,  0 users,  load average: 0.01, 0.02, 0.00
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT


# How to use:
## 1. Define host or vm list in the header of tiny_cluster_helper.sh

    ### Define your hosts/vms list here - BEGIN ################################################
    all="
    vm0
    vm1
    vm2
    vm3
    vm4
    vm5
    vm6
    vm7
    "
    worker="
    vm1
    vm2
    vm3
    "
    GROUP_LIST="all|worker"
    ### Define your hosts/vms list here - END ################################################

## 2. Source this script

       source tiny_cluster_helper.sh

## 3. Create ssh equivalent

       ssheq all

    Note: all nodes will use the same password.

## 4. Done. Now please enjoy the commands listed as below
**c**       : copy file to remote nodes

**e**       : Execute command in remote nodes

**e_px**    : Same as e but in parallel

**e_tty**   : Same as e but with tty



# Examples

   ## Copy file or folder to remote nodes.   
    
    [root@vm0 ~]$ c all mydata.csv /tmp
    ### Copy file/folder (mydata.csv) to (vm0:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm1:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm2:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm3:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm4:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm5:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm6:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00    
    ### Copy file/folder (mydata.csv) to (vm7:/tmp). ###
    mydata.csv                                             100%    0     0.0KB/s   00:00
       
   ## Execute command/script on remote nodes
    
    [root@vm0 ~]$ time e all date
    ### Execute command (date) on node (vm0). ###
    Tue Jul  9 22:35:09 EDT 2019
    ### Execute command (date) on node (vm1). ###
    Tue Jul  9 22:35:09 EDT 2019
    ### Execute command (date) on node (vm2). ###
    Tue Jul  9 22:35:09 EDT 2019
    ### Execute command (date) on node (vm3). ###
    Tue Jul  9 22:35:10 EDT 2019
    ### Execute command (date) on node (vm4). ###
    Tue Jul  9 22:35:10 EDT 2019
    ### Execute command (date) on node (vm5). ###
    Tue Jul  9 22:35:10 EDT 2019
    ### Execute command (date) on node (vm6). ###
    Tue Jul  9 22:35:10 EDT 2019
    ### Execute command (date) on node (vm7). ###
    Tue Jul  9 22:35:10 EDT 2019

    real	0m0.561s
    user	0m0.036s
    sys	0m0.065s
       
   ## Execute command/script on remote nodes with tty
       
    [root@vm0 ~]$ time e_tty all date
    ### Execute command (date) on node (vm0) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm0 closed.
    ### Execute command (date) on node (vm1) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm1 closed.
    ### Execute command (date) on node (vm2) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm2 closed.
    ### Execute command (date) on node (vm3) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm3 closed.
    ### Execute command (date) on node (vm4) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm4 closed.
    ### Execute command (date) on node (vm5) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm5 closed.
    ### Execute command (date) on node (vm6) with ssh tty option. ###
    Tue Jul  9 22:34:07 EDT 2019
    Shared connection to vm6 closed.
    ### Execute command (date) on node (vm7) with ssh tty option. ###
    Tue Jul  9 22:34:08 EDT 2019
    Shared connection to vm7 closed.

    real	0m0.654s
    user	0m0.035s
    sys	0m0.070s
    
   ## Execute command/script on remote nodes in parallel

    [root@vm0 ~]$ time e_px all date
    [1] 31496
    ### Execute command (date) on node (vm0) in background. ###
    ### Execute command (date) on node (vm1) in background. ###
    ### Execute command (date) on node (vm2) in background. ###
    ### Execute command (date) on node (vm3) in background. ###
    ### Execute command (date) on node (vm4) in background. ###
    ### Execute command (date) on node (vm5) in background. ###
    ### Execute command (date) on node (vm6) in background. ###
    ### Execute command (date) on node (vm7) in background. ###
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    Tue Jul  9 22:34:45 EDT 2019
    [1]+  Done                    _exec_on $@

    real	0m0.105s
    user	0m0.038s
    sys	0m0.064s




# Update Logs:
20160701, created

20181102, Modify copy_from function.

20190708, Remove some unrelevant functions. Improve and Simplify the rest.



