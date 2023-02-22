#!/bin/env

if [ -z "$1" ]; then

echo "Enter name"
exit 1
fi

COMPONENT=$1
ZONE_ID="Z06159752FUGC3W0H30QO"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=Mydevops | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')

echo ${AMI_ID}

create_ec2() {
Pravite_IP=$(aws ec2 run-instances \
    --image-id ${AMI_ID} \
    --instance-type t2.micro \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
    --security-group-ids ${SGID} \
    --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" |  jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

 sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
    }


    if [ "$1" == "all" ]; then
      for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis ; do
        COMPONENT=$component
        create_ec2
      done
    else
      create_ec2
    fi