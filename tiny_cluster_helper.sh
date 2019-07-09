#!/bin/bash
# Tiny cluster helper: A tiny tool to make it easy to run command over ssh on cluster hosts/vms.
# Creator: zhaopinglu77@gmail.com
# Update Logs:
# 201607, created
# 20181102, Modify copy_from function.
# 20190708, Remove some unrelevant functions. Improve and Simplify the rest.

# How to use:
# 1. Put this single script in any place. Add your host or vm list in below. 

# 2. Source this script, like: "source tiny_cluster_helper.sh"

# 3. Create ssh equivalent, eg: "ssheq all", then input the password. Note: all node should have the same password.

# 4. Enjor the following commands:
#	c: copy file or folder to remote nodes. 	eg: c all mydata.csv /tmp
#	e: execute command/script on remote nodes. 	eg: e all hostname
#	e_tty: same as command "e" but with tty. 
#	e_px: same as command "e" but will execute command in parallel. 

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
vm4
vm5
vm6
vm7
"

tester="
oracle@vm1
oracle@vm2
oracle@vm3
"

GROUP_LIST="all|worker|tester"

### Define your hosts/vms list here - END ################################################
SSH_OPTIONS="-C -o ControlMaster=auto -o ControlPersist=6000s -o ConnectTimeout=4 -o ControlPath=/tmp/ssh_mux_%h_%p_%r"



function node_name_list() {
NODE_GROUP=$1
[[ -z $NODE_GROUP ]] && echo "Usage: node_name_list $GROUP_LIST" && return 1
for i in ${!NODE_GROUP}
do
	echo $i
done
}

function ssh-auto-id () {
NODE=$1
PASSWD=$2

/usr/bin/expect <(cat << EOF
#set timeout 10
spawn ssh-copy-id $NODE
expect {
"Are you sure you want to continue connecting (yes/no)?" { send "yes\r"; exp_continue }
"Permission denied, please try again." { send_user "\r\n\r\n( Wrong password found. Please make sure your input. Quit. )\r\n\r\n"; exit 1 }
"s password:" { send_user "\r\n\r\n ( Password sent, waiting for response! )\r\n\r\n"; send "$PASSWD\r"; exp_continue }
}
EOF
)
RET=$?
[[ $RET -ne 0 ]] && echo "Execution abort. Please check the password or ssh service." && exit 1
}



function ssheq() {
[[ -z $1 ]] && echo "Usage: ${FUNCNAME[0]} $GROUP_LIST" && return 1
NODE_GROUP=$1
[[ ! -f $HOME/.ssh/id_rsa ]] && echo "Didn't see file $HOME/.ssh/id_rsa. Generate ssh key" && ssh-keygen

echo "Remove existing keys from $HOME/.ssh/know_hosts file."
for NODE in `node_name_list $NODE_GROUP`
do
	[[ -f $HOME/.ssh/known_hosts ]] && sed -i "/$NODE/d" $HOME/.ssh/known_hosts
done

echo -n "Create ssh equivalent. Please input user password:"
read -s PASSWD; echo $PASSWD| sed 's/./*/g'

for NODE in `node_name_list $NODE_GROUP`
do
	ssh-auto-id $NODE $PASSWD
done

echo "Check ssh-equivalent from current node to node group $NODE_GROUP:"
for NODE in `node_name_list $NODE_GROUP`
do
        ssh -n -o StrictHostKeyChecking=no $NODE 'echo "$USER@$(hostname): $(date)"' 2>&1|grep -v "Authorized uses only."
done
}


function copy_to_force() {
NODE_GROUP=$1
FILE=$2
DST=${3:-.}

[[ -z $FILE ]] && echo "Usage: ${FUNCNAME[0]} $GROUP_LIST source_single_file_or_folder_name [dest_folder_on_remote]" && return 1

for NODE in `node_name_list $NODE_GROUP`
do
	echo "### Copy file/folder ($FILE) to (${NODE}:$DST). ###"
	scp -rp $FILE ${NODE}:$DST
done
}

function c() {
[[ -z $1 ]] && echo "Usage: ${FUNCNAME[0]} $GROUP_LIST source_single_file_or_folder_name [dest_folder_on_remote]" && return 1
copy_to_force $@
}


function _exec_on() {
NODE_GROUP=$1
shift
FILE="$1"
shift

[[ -z $FILE ]] && echo "Usage: _exec_on $GROUP_LIST script_or_cmd" && return 1


if [ -f "$FILE" ]; then
	copy_to $NODE_GROUP "$FILE"
	CMD=`basename "$FILE"`
fi

for NODE in `node_name_list $NODE_GROUP`
do
	echo "### Execute command (${FILE}) on node (${NODE})${PX_OPTION:+ in background}${SSH_TTY_OPTION:+ with ssh tty option}. ###"
	if [ -f "$FILE" ]; then
		if [[ -z $PX_OPTION ]]; then
			ssh $SSH_OPTIONS $SSH_TTY_OPTION ${NODE} ./$CMD $@
		else
			ssh $SSH_OPTIONS $SSH_TTY_OPTION ${NODE} ./$CMD $@ &
		fi
	else
		if [[ -z $PX_OPTION ]]; then
			ssh $SSH_OPTIONS $SSH_TTY_OPTION ${NODE} $FILE $@
		else
			ssh $SSH_OPTIONS $SSH_TTY_OPTION ${NODE} $FILE $@ &
		fi
	fi
done
wait
}

function e() {
[[ -z $1 ]] && echo "Usage: ${FUNCNAME[0]} $GROUP_LIST command [arguments]" && return 1
SSH_TTY_OPTION=""
PX_OPTION=""
_exec_on $@
}

function e_tty() {
[[ -z $1 ]] && echo "Usage: ${FUNCNAME[0]} $GROUP_LIST command [arguments]" && return 1
SSH_TTY_OPTION="-t"
PX_OPTION=""
_exec_on $@
}

function e_px() {
[[ -z $1 ]] && echo "Usage: ${FUNCNAME[0]} $GROUP_LIST command [arguments]" && return 1
SSH_TTY_OPTION=""
PX_OPTION="on"
_exec_on $@ &
wait
}


function waitpid(){
WPID=$1
[[ -z $WPID ]] && echo Usage: waitpid 123456 \&\& ./your_script.sh && return 1
echo Hold until the process $WPID quit...
while [ -e /proc/$1 ];
do sleep 1
echo -n .
done
echo waitpid done!
}

function waitpids(){
echo Hold until all processes \($@\) quit...
for WPID in "$@"
do
waitpid $WPID
done
}



#function copy_from() {
#set -vx
#NODE_GROUP=$1
#FILE_LIST=$2
#DST=${3:-`pwd`}
#[[ -z "$FILE_LIST" ]] && echo -e "Usage: copy_from NODE_GROUP single_filename_in_remote [local_dest_dir]\nUsage: copy_from NODE_GROUP \"multiple_filenames_in_remote\" [local_dest_dir]" && return 1
#
#mkdir -p $DST
#for NODE in `node_name_list $NODE_GROUP`
#do
#	arr=(${!NODE//@/ })
#	HOST=${arr[1]}
#	#for FILE in `ssh $SSH_OPTIONS ${!NODE} ls "$FILE_LIST"`
#	for FILE in `ssh $SSH_OPTIONS ${!NODE} ls -rt $FILE_LIST`
#	do
#		#//: global replace, @ will be replace by ' ', the () means to convert the result to string array.
#		#DSTFILE=$DST/${HOST}.`basename $FILE`
#		DSTFILE=$DST/${NODE}_${HOST}.`basename $FILE`
#		echo Copy ${!NODE}:$FILE to $DSTFILE
#		scp -p ${!NODE}:$FILE $DSTFILE
#	done
#done
#set +vx
#
#}
