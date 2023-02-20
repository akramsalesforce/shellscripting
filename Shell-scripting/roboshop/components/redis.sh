
source components/Common.sh

print "setup redis yum repo"

curl -f -L "https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo" -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
statcheck $?

print "Install redis "
yum install redis-6.2.9 -y &>>$LOG_FILE
statcheck $?

if [ -f /etc/redis.conf ]; then
  print "updating redis config file"
  sed -i -e '/s/127.0.0.1/0.0.0.0/'  /etc/redis.conf

  else
    print "file doesn't exit"
  fi
statcheck $?
if [ -f /etc/redis/redis.conf ]; then
  print "updating redis config file"
  sed -i -e '/s/127.0.0.1/0.0.0.0/'  /etc/redis.conf
  else
    print "file doesn't exit"
  fi
statcheck $?

print "Starting redis service"
systemctl enable redis &>>$LOG_FILE && systemctl start redis &>>$LOG_FILE
statcheck $?

