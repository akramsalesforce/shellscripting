#!/bin/bash

statcheck(){
# check the status of last excuted command
if  [ $1 -eq 0 ]; then

  echo -e "\e[35m Success \e[0m"

else

  echo -e "\e[35m Failure \e[0m"

exit 2
fi

}

USER_ID=$(id -u)
{

if [ "$USER_ID" -ne 0 ];then

echo you should run your script as sudo or root user

exit 1

fi
}

print(){

echo -e "\n------------------------$1-----------------" &>>$LOG_FILE
echo -e "\e[36m $1 \e[0m"

}

LOG_FILE=/tmp/roboshop.log

rm -f $LOG_FILE

APP_USER=roboshop
App_user_funcation(){

   id ${APP_USER} &>>$LOG_FILE

    if [ "$?" -ne 0 ]; then
      print "Create application user"
      print "User doesnt exist adding user ------>\n"
      useradd ${APP_USER} &>>$LOG_FILE

    else
      print "User already exist  ------>"
    fi
    statcheck $?

  print "cleanup old content"
  rm -rf /home/${APP_USER}/${Calluser} &>>$LOG_FILE
  statcheck $?
  print "App content"
  cd /home/${APP_USER} &>>$LOG_FILE && unzip -o /tmp/${Calluser}.zip &>>$LOG_FILE \
   && mv  ${Calluser}-main  ${Calluser} &>>$LOG_FILE
  statcheck $?

  print "Install app dependency"
  cd /home/${APP_USER}/${Calluser}  && npm install &>>$LOG_FILE
  statcheck $?

}

service_set(){

   print "File permission for user"
    chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}   &>>$LOG_FILE
    statcheck $?


    print "configure MongoBD and redis"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.intarnet/' \
          -e 's/MONGO_ENDPOINT/mongodb.roboshop.intarnet/' \
          -e 's/REDIS_ENDPOINT/redis.roboshop.intarnet/' \
          -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.intarnet/' \
          -e 's/CARTENDPOINT/cart.roboshop.intarnet/' \
          -e 's/DBHOST/mysql.roboshop.intarnet/' \
          /home/${APP_USER}/${Calluser}/systemd.service  &>>$LOG_FILE \
          && mv /home/${APP_USER}/${Calluser}/systemd.service /etc/systemd/system/${Calluser}.service &>>$LOG_FILE
    statcheck $?



}
Nodejs(){

  print "Configure Yum Repo"
  curl -fsSL "https://rpm.nodesource.com/setup_16.x" | bash - &>>$LOG_FILE
  statcheck $?

  print "install nodejs"
  yum install nodejs gcc-c++ -y &>>$LOG_FILE
  statcheck $?


App_user_funcation



  print "download app component"
  curl -f -s -L -o /tmp/${Calluser}.zip "https://github.com/roboshop-devops-project/${Calluser}/archive/main.zip" &>>$LOG_FILE
  statcheck $?

service_set




  print "start user"

  systemctl daemon-reload &>>$LOG_FILE && systemctl start ${Calluser} &>>$LOG_FILE && systemctl enable ${Calluser} &>>$LOG_FILE

  statcheck $?


}

Maven() {

  print "Install mavin"

   yum install maven -y &>>$LOG_FILE
statcheck $?
App_user_funcation

print "Maven Packing"

cd /home/${APP_USER}/${Calluser}  && mvn clean package &>>$LOG_FILE && mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE

statcheck $?

service_set

}
