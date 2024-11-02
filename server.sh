echo "Be sure to be root or to be sudoer"
read -p "Full email: " email

# Update the system
apt-get update
apt-get upgrade
apt-get install apache2 openssh-server git gitweb vim -y

# Activate CGI
a2enmod cgi

# Enable apache
systemctl enable apache2

# Add user git
adduser git
passwd git
su - git

# SSH directory
mkdir ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys && chmod 600 .ssh/authorized_keys

# Create the repos directory
mkdir ~/repos/

# Configure gitweb
echo "our $projectroot = "/home/git";" >| /etc/gitweb.conf

# Start apache2
systemctl start apache2

# Email SSH
ssh-keygen -C $email
cat ~/.ssh/id_rsa.pub | ssh git@<PI_IP_or_hostname> "cat >> ~/.ssh/authorized_keys"

