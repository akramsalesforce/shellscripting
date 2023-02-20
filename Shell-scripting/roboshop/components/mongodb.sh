
source components/Common.sh

print "Set Yum Repos"
curl -f -s -o /etc/yum.repos.d/mongodb.repo "https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo" &>>$LOG_FILE
statcheck $?

print "Installing MongoBD"
yum install -y mongodb-org &>>$LOG_FILE
statcheck $?

print "Updating mongod Config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statcheck $?



print "start mongoDB"
systemctl start mongod && systemctl enable mongod &>>$LOG_FILE
statcheck $?




