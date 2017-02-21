## PART 1
### Section 1
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
### Section 2
sudo yum -y update google-cloud-sdk &&
sudo yum -y update &&
sudo yum -y install epel-release &&
sudo yum -y install python-pip &&
sudo pip install -U pip &&
sudo pip install 'apache-libcloud==1.2.1' &&
sudo pip install 'docker-py==1.9.0' &&
sudo yum -y install git ansible &&
sudo yum -y install net-tools
### Section 3
# Run following command and enter empty passphrase
ssh-keygen -t rsa -f ~/.ssh/id_rsa -C cc_chanat
#Open Public File and change the "ssh-rsa ahsghagshagsh..." like content to "cc_chanat:ssh-rsa ajshajhsjshj"
vi ~/.ssh/id_rsa.pub
chmod 400 ~/.ssh/id_rsa
# Finally we register our keys with Google 
gcloud compute project-info add-metadata --metadata-from-file sshKeys=~/.ssh/id_rsa.pub

### Section 4
########################################################################
###        REBOOT THE HOST AND CONNECT after few minutes             ###
########################################################################
sudo shutdown -r now

## Part 2
### Section 1
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

sudo yum -y install docker-engine-1.11.2
### Section 2
sudo sed -i '/ExecStart/c\ExecStart=/usr/bin/docker daemon --storage-driver=overlay' /usr/lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl start docker.service
# This following line verifies Docker installed and started successfully
sudo docker run hello-world


## Part 3
### Section 1
git clone https://github.com/electric-cloud/dcos-gce
cd dcos-gce
cp scripts/.ansible.cfg ~/.ansible.cfg

## Part 4
# Open vim group_vars/all and fill in first 4 fields according to your project, 
# zone and the Public IP of the bootstrap node, my sample looks like…
# ---
# project: microservices-poc-143218 
# subnet: default
# login_name: vbiyani 
# bootstrap_public_ip: 130.211.202.228 
# zone: us-central1-b 

# Open hosts file in the folder dcos-gce. Now here you need to give the private address of bootstrap node +1. 
# So if bootstrap nodes private address is 10.128.0.2 
# In some cases this next IP is taken and script will throw error saying the node with that IP exists, then keep incrementing it till script works
# master0 ip=10.128.0.3
# This will create a master node
ansible-playbook -i hosts install.yml
# Take a cup of coffee, this will take some time
# Finally Create two private and two public nodes - you can customize names etc. as needed below

ansible-playbook -i hosts add_agents.yml --extra-vars "start_id=0001 end_id=0002 agent_type=private"
ansible-playbook -i hosts add_agents.yml --extra-vars "start_id=0003 end_id=0004 agent_type=public"

## Finally open up ports 8080 on master and as needed by apps on master/agent nodes
