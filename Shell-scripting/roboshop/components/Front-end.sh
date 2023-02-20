
source components/Common.sh

print " install nginx "
yum install nginx -y &>>$LOG_FILE
statcheck $?

print "downloading  Nginx path "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old nginx content"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
statcheck $?


cd /usr/share/nginx/html

print "Extracting Archive"

 unzip /tmp/frontend.zip &>>$LOG_FILE && mv frontend-main/static/* . &>>$LOG_FILE
 #&& MV /static/* . &>>$LOG_FILE

statcheck $?

print "updating the config file"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
 statcheck $?

 print "starting nginx service"


systemctl start nginx && systemctl enable nginx &>>$LOG_FILE
statcheck $?



# systemctl enable nginx
# systemctl start nginx