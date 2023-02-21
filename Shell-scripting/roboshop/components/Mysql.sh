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

echo 'show databases' | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then

print "change default password"
 echo -e "SET Password for 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
 DEFULT_ROOT_PASSWD=$( grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

 mysql --connect-expired-password -uroot -p"${DEFULT_ROOT_PASSWD}" </tmp/rootpass.sql &>>$LOG_FILE

statcheck $?
fi

echo show plugins | mysql -uroot -pRoboShop@1 2>>$LOG_FILE | grep validate_password &>>$LOG_FILE

if [ $? -eq 0 ]; then

  print "Uninstall password validate plugins"
  echo 'uninstall plugin validate_password;' >/tmp/pass-validate.sql

  mysql --connect-expired-password -uroot -pRoboShop@1 < tmp/pass-validate.sql &>>$LOG_FILE

statcheck $?

  fi



print "Download schema"
curl -f -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "Extract schema"
cd /tmp  && unzip-o mysql.zip &>>$LOG_FILE
statcheck $?

print "Load  schema"
ccd mysql-main &>>$LOG_FILE && mysql -uroot -pRoboShop@1 <shipping.sql &>>$LOG_FILE
statcheck $?


#