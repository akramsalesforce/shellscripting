source components/Common.sh

print "Set Yum Repos"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo "https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo" &>>$LOG_FILE
statcheck $?


print "Installing MySql"
yum install mysql-community-server -y &>>$LOG_FILE
statcheck $?

print "start MySql"

systemctl enable mysqld  &>>$LOG_FILE && systemctl start mysqld  &>>$LOG_FILE

statcheck $?

#grep temp /var/log/mysqld.log &>>$LOG_FILE && mysql_secure_installation &>>$LOG_FILE  mysql -uroot -pRoboShop@1 &>>$LOG_FILE