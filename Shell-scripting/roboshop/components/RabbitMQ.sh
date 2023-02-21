

print "configure yum repos"
curl -f -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOG_FILE
statcheck $?


print "Install go lang and rabbitmg"


curl -f -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

yum install erlang -y
statcheck $?

print "start RabbitMQ service"
systemctl enable rabbitmq-server  &&  systemctl start rabbitmq-server &>>$LOG_FILE
statcheck $?

print "create application user"

rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
                                          statcheck $?





