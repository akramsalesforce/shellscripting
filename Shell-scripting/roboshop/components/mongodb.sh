
source components/Common.sh

print "Downloading MongoDB package"
curl -f -s -o /etc/yum.repos.d/mongodb.repo "https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo" &>>$LOG_FILENAME
statcheck $?

Print "Installing Mongo DB on server"
yum install -y mongodb-org &>>$LOG_FILENAME
statcheck $?

Print "Updating mongod Config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf


print "Download schema"

curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILENAME
statcheck $?

cd /tmp


print "Extracting Archive"

 unzip mongodb.zip &>>$LOG_FILE
 #&& MV /static/* . &>>$LOG_FILE

statcheck $?

cd mongodb-main

print "uploading catalogue file"

 mongo < catalogue.js &>>$LOG_FILE
 #&& MV /static/* . &>>$LOG_FILE

statcheck $?

print "uploading user file"
mongo < users.js &>>$LOG_FILE
 #&& MV /static/* . &>>$LOG_FILE

statcheck $?

systemctl start mongod && systemctl enable mongod &>>$LOG_FILE
statcheck $?




