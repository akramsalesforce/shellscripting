
source components/Common.sh

print "install nginx"
yum install nginx -y
statcheck $?

print "downloading the HTDOCS content and deploy under the Nginx path " &>>$LOG_FILE
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old nginx content"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE



cd /usr/share/nginx/html

print "Extracting Arachive"

 unzip /tmp/frontend.zip && mv frontend-main/* . && MV static/* . &>>$LOG_FILE

statcheck $?

print "updating the config file"
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
 statcheck $?

 print "starting nginx service"

 systemctl start nginx &>>$LOG_FILE
statcheck $?
systemctl enable nginx



# systemctl enable nginx
# systemctl start nginx