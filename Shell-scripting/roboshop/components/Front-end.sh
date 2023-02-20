
source components/Common.sh

print "install nginx" &>>$LOG_FILE
yum install nginx -y
statcheck $?

print "downloading the HTDOCS content and deploy under the Nginx path " &>>$LOG_FILE
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old nginx content" &>>$LOG_FILE

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE



cd /usr/share/nginx/html

print "Extracting Arachive" &>>$LOG_FILE

 unzip /tmp/frontend.zip && mv frontend-main/* . && MV static/* . &>>$LOG_FILE

statcheck $?

print "updating the config file" &>>$LOG_FILE
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
 statcheck $?

 print "starting nginx service" &>>$LOG_FILE

 systemctl start nginx &>>$LOG_FILE
statcheck $?
systemctl enable nginx



# systemctl enable nginx
# systemctl start nginx