#!/ur/bin/env bash
HOSTS=(
	'linuxfoundation.org 443'
	'ubuntu.com 443'
	'debian.org 443'
)


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


# function that runs the ssl audit on a host got from $1
audit_ssl_of_host(){
	#echo "host is: $host"
	HOST=$1
	PORT=$2
	printf "%-8s %-8s %-8s %-5s \n" "HOST is:" "$HOST" "Port is:" "$PORT"
	#./testssl.sh --warnings batch --html $HOST:$PORT
}

# running the audit on all HOSTS from HOSTS-Array
for host in "${HOSTS[@]}"; do
	audit_ssl_of_host $host
done

exit
