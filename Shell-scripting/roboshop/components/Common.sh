#!/bin/bash

statcheck(){
# check the status of last excuted command
if  [ $1 -eq 0 ]; then

  echo -e "\e[35mSuccess\e[0m"

else

  echo -e "\e[35mFailure\e[0m"

exit 2
fi

}

USER_ID=$(id u)
{

if [ "$USER_ID" -ne 0 ];then

echo you should run your script as sudo or root user

exit 1

fi
}

print(){

echo -e "\n------------------------$1-----------------" &>>$LOG_FILE
echo -e "\e[36m $1 [0m"

}

LOG_FILE=/tmp/roboshop.log

rm -f $LOG_FILE
