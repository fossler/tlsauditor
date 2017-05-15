#!/usr/bin/env bash
HOSTS=(
	'linuxfoundation.org 443'
	'ubuntu.com 443'
	'debian.org 443'
)

# check requirements
# ######################################################################

# Check if folder for the reports exist, else create it
[[ ! -d scan-reports ]] && mkdir -p scan-reports

# Check if testssl.sh suite is available, if not clone it from github
if [[ ! -d testssl.sh ]]; then
	git clone https://github.com/drwetter/testssl.sh.git
else
	cd testssl.sh/
	git pull
	if [[ $? -ne 0 ]]; then
		printf "******************************************\n"
	  printf "* [ ERROR ]\n"
	  printf "*\n"
	  printf "* Exited with errors in: git pull\n"
	  printf "*\n"
	  printf "******************************************\n"
		exit 1
	fi
fi

EXEC_PATH=$(dirname "$(readlink -f "$0")")
echo "EXEC_PATH is: $EXEC_PATH"

# function that runs the ssl audit on a host. Takes $1 as input
audit_ssl_of_host(){
	DATE=$(date +%Y-%m-%d)
	TIME=$(date +%H:%M:%S)
	HOST=$1
	PORT=$2
	printf "%-8s %-8s %-8s %-5s \n" "HOST is:" "$HOST" "Port is:" "$PORT"
	$EXEC_PATH/testssl.sh --warnings batch --htmlfile ${EXEC_PATH%/*}/scan-reports/"$HOST"_"$PORT"_"$DATE"_"$TIME".html  $HOST:$PORT
}

# Errors logging function
error_log (){
	EXIT_ERROR=$(echo $?)
	DATE=$(date +%Y-%m-%d)
	TIME=$(date +%H:%M:%S)
	LOG_FILE="${EXEC_PATH%/*}/ERROR_LOG_$DATE.log"
	if [[ $EXIT_ERROR -ne 0 ]]; then
		echo "$DATE $TIME $host exited with Exit-Error: $EXIT_ERROR" >> $LOG_FILE
	fi
}


# running the audit on all HOSTS from HOSTS-Array
for host in "${HOSTS[@]}"; do
	audit_ssl_of_host $host
	error_log
done

exit
