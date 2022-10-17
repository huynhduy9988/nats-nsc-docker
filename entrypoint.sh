#!/bin/bash

OPERATOR_NAME=$1
ACCOUNT_NAME=$2
USER_NAME=$3

cd /home/admin

if [ -d "/home/admin/jwt" ]
then
   echo "Server already initialized before"
else
    # create jwt dir
    mkdir jwt
    # Add Operator, Account, User
    nsc add operator ${OPERATOR_NAME}
    nsc add account ${ACCOUNT_NAME}
    nsc add user ${USER_NAME}
    nsc generate creds -a ${ACCOUNT_NAME} -n ${USER_NAME}
    nsc generate config --nats-resolver --sys-account ${ACCOUNT_NAME} --config-file nats.conf.tmp
    sed "38,40d" nats.conf.tmp > nats.conf
    nsc describe account -R > jwt/$(nsc describe account -F sub | sed "s/\"//g").jwt
fi

cat ~/.local/share/nats/nsc/keys/creds/Operator1/Account1/User1.creds

nats-server -c /home/admin/nats.conf -V &

while :
do
    sleep 1
done

