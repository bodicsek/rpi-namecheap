#/bin/bash

function ipcheck {
    isdiff=1
    hostlist=$2
    ipaddressnew=`dig +short myip.opendns.com @resolver1.opendns.com`
    echo Current ip address: $ipaddressnew
    for host in ${hostlist[@]}
    do
        if [ $host == "@" ]; then
            ipaddresscurrent=`nslookup $1 | grep Address | grep -v "#" | cut -f2 -d" "`
        else
            ipaddresscurrent=`nslookup $host.$1 | grep Address | grep -v "#" | cut -f2 -d" "`
        fi
        echo Registered ip address: $ipaddresscurrent
        diffcheck=`echo $ipaddresscurrent | grep -c $ipaddressnew`
        if [ $diffcheck -eq 0 ];then
            isdiff=0
        fi
    done
}

function update {
    echo Updating host: $2
    hostlist=$1
    for host in ${hostlist[@]}
    do
        echo $host
        response=`curl https://dynamicdns.park-your-domain.com/update?host=$host\&domain=$2\&password=$3`
        echo $response
    done
}

isdiff='1'

hostlist=("@")
domain=$DOMAIN
password=$PASSWORD

while true; do
    echo Running...
    ipcheck $domain $hostlist
    if [ $isdiff -eq 0 ]; then
        update $hostlist $domain $password
    fi
    sleep 30
done
