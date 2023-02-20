
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

print "Download schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "Extract schema"
cd /tmp && unzip -o mongodb.zip  &>>$LOG_FILE
statcheck $?

print "Load schema"

cd mongodb-main
for schema in catalogue users; do
echo -e "updating schema for ${schema}"
mongo < ${schema}.js &>>$LOG_FILE
statcheck $?
done

print "start mongoDB"
systemctl start mongod && systemctl enable mongod &>>$LOG_FILE
statcheck $?




