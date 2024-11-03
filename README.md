# Git Server on a Pi
Selfhost a git server.

## Walkthrough process

```bash
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

# Bare clone
cd && cd repos
git clone https://url_to_other_repo.com/repo.git
git update-server-info
logout

# Configure gitweb
vi /etc/gitweb.conf # edit $projectroot to be /home/git/repos

# Start apache2
systemctl start apache2

# Email SSH
ssh-keygen -C "youremail@mailprovider.com"
cat ~/.ssh/id_rsa.pub | ssh git@<PI_IP_or_hostname> "cat >> ~/.ssh/authorized_keys"
```

On client :
```bash
# Clone and add

git clone ssh://git@<PI_IP_or_hostname>/home/git/repos/previous_repo.git
cd previous_repo.git
touch HELLO_WORLD.TXT
git add HELLO_WORLD.TXT
git commit -a -m "adding first file to the project"
git push origin
```
And refresh the [page](http://PI_IP/gitweb)

## Multiple origins

On client :
```bash
cd my_repo
git remote add pi ssh://git@<PI_IP_or_hostname>/home/git/repos/my_repo.git
```

## gitweb.conf example

```conf
# path to git projects (<project>.git)
our $projectroot = "/home/git";

# directory to use for temp files
$git_temp = "/tmp";

@diff_opts = ();

# Features
$feature{'blame'}{'default'} = [1];
$feature{'blame'}{'override'} = 1;

$feature{'log'}{'default'} = [1];
$feature{'log'}{'override'} = 1;

$feature{'grep'}{'default'} = [1];
$feature{'grep'}{'override'} = 1;

$feature{'highlight'}{'default'} = [1];
$feature{'highlight'}{'override'} = 1;

$feature{'heads'}{'default'} = [1];
$feature{'heads'}{'override'} = 1;

$feature{'tags'}{'default'} = [1];
$feature{'tags'}{'override'} = 1;

$feature{'commitdiff'}{'default'} = [1];
$feature{'commitdiff'}{'override'} = 1;

$feature{'snapshot'}{'default'} = ['zip', 'tgz'];
$feature{'snapshot'}{'override'} = 1;

# Sitename
our $site_name = "Git server";
```
