echo "Iniciando $NAME como `whoami`"
#================================================================================
PROJECT='clivet'
GIT_REP='https://gitlab.com/wannabe/CLIVET.git'
USER='clivet_user'
#================================================================================
apt update
apt upgrade
echo "=============Users============"
groupadd --system webapps
useradd --system --gid webapps --shell /bin/bash --home /var/www/$PROJECT $USER
echo "=============Virtual============"
apt install python-virtualenv
mkdir -p /var/www/$PROJECT
cd /var/www/$PROJECT
git clone $GIT_REP $PROJECT
mkdir -p /var/www/$PROJECT/$PROJECT/temp/logs
chown $USER /var/www/$PROJECT/
cd /var/www/$PROJECT/
su - $USER
#write this comands https://github.com/yuselenin/clivet_config/blob/master/configutation_in_user.sh
chown -R $USER:webapps /var/www/$PROJECT
chmod -R g+w /var/www/$PROJECT
echo "=============Gunicorn============"
cd /var/www/$PROJECT
chown -R $USER:users /var/www/$PROJECT
chmod u+x bin/gunicorn_start
wget https://raw.githubusercontent.com/yuselenin/clivet_config/master/gunicorn_start -P /var/www/$PROJECT/bin/
echo "=============supervisor============"
apt install supervisor
wget https://raw.githubusercontent.com/yuselenin/clivet_config/master/clivet.conf -P /etc/supervisor/conf.d/
mkdir -p /var/www/$PROJECT/logs/
touch /var/www/$PROJECT/logs/gunicorn_supervisor.log 
chown -R $USER:webapps /var/www/$PROJECT
supervisorctl reread
supervisorctl update
supervisorctl status $PROJECT
# supervisorctl restart $PROJECT 
echo "=============nginx============"
apt install nginx
echo "STATUS"
service nginx start
wget https://raw.githubusercontent.com/yuselenin/clivet_config/master/clivet -P /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/$PROJECT /etc/nginx/sites-enabled/$PROJECT
service nginx restart
