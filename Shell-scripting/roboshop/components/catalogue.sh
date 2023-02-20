
source components/Common.sh

print "Configure Yum Repo"
curl -fsSL "https://rpm.nodesource.com/setup_16.x" | bash - &>>$LOG_FILE
statcheck $?

print "install nodejs"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
statcheck $?

User=Roboshop
print "Create application user"
useradd $(User) &>>$LOG_FILE
statcheck $?

print "download app component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old content"
rm -rf /home/roboshop/catalogue &>>$LOG_FILE
statcheck $?
print "App content"
cd /home/roboshop  unzip -o /tmp/catalogue.zip &>>$LOG_FILE && mv catalogue-main catalogue &>>$LOG_FILE
statcheck $?

print "Install app dependency"
cd /home/roboshop/catalogue &>>$LOG_FILE && npm install &>>$LOG_FILE
statcheck $?

