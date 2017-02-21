sudo yum -y update google-cloud-sdk &&
sudo yum -y update &&
sudo yum -y install epel-release &&
sudo yum -y install python-pip &&
sudo pip install -U pip &&
sudo pip install 'apache-libcloud==1.2.1' &&
sudo pip install 'docker-py==1.9.0' &&
sudo yum -y install git ansible

sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

sudo yum -y install docker-engine-1.11.2
