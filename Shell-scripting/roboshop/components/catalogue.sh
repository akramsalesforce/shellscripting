
source components/Common.sh

print "Configure Yum Repo"
curl -fsSL "https://rpm.nodesource.com/setup_16.x" | bash - &>>$LOG_FILE
statcheck $?

print "install nodejs"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
statcheck $?




id ${APP_USER} &>>$LOG_FILE

if [ "$?" -ne 0 ]; then
  print "Create application user"
   print "User doesnt exist adding user ------>\n"
  useradd ${APP_USER} &>>$LOG_FILE

else
  print "User already exist  ------>"
fi
statcheck $?

print "download app component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old content"
rm -rf /home/${APP_USER}/catalogue &>>$LOG_FILE
statcheck $?
print "App content"
cd /home/${APP_USER} &>>$LOG_FILE && unzip -o /tmp/catalogue.zip &>>$LOG_FILE && mv catalogue-main catalogue &>>$LOG_FILE
statcheck $?

print "Install app dependency"
cd /home/${APP_USER}/catalogue  && npm install &>>$LOG_FILE
statcheck $?

print "File permission for user"
chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}   &>>$LOG_FILE
statcheck $?


print "configure MongoBD"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.intarnet/' /home/${APP_USER}/catalogue/systemd.service  &>>$LOG_FILE && mv /home/${APP_USER}/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
statcheck $?

print "start catalogue"

systemctl daemon-reload &>>$LOG_FILE && systemctl start catalogue &>>$LOG_FILE && systemctl enable catalogue &>>$LOG_FILE

statcheck $?