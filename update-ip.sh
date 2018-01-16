#/bin/bash

function ipcheck {
    isdiff=1
    domain=$1
    hostlist=$2
    ipaddressnew=`dig +short myip.opendns.com @resolver1.opendns.com`
    echo Current ip address: $ipaddressnew
    for host in ${hostlist[@]}
    do
        if [ $host == "@" ]; then
            ipaddresscurrent=`nslookup $domain | grep Address | grep -v "#" | cut -f2 -d" "`
        else
            ipaddresscurrent=`nslookup $host.$domain | grep Address | grep -v "#" | cut -f2 -d" "`
        fi
        echo Registered ip address for $host.$domain : $ipaddresscurrent
        diffcheck=`echo $ipaddresscurrent | grep -c $ipaddressnew`
        if [ $diffcheck -eq 0 ];then
            isdiff=0
        fi
    done
}

function update {
    hostlist=$1
    domain=$2
    for host in ${hostlist[@]}
    do
        echo Updating $host.$domain :
        response=`curl https://dynamicdns.park-your-domain.com/update?host=$host\&domain=$2\&password=$3`
        echo $response
    done
}

isdiff='1'

IFS='|' read -r -a hostlist <<< "$HOSTLIST"
domain=$DOMAIN
password=$PASSWORD
seconds=$SECONDS

while true; do
    echo Running...
    ipcheck $domain $hostlist
    if [ $isdiff -eq 0 ]; then
        update $hostlist $domain $password
    fi
    sleep $seconds
done

