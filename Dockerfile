# docker build -t debian:PerfectPanel .
FROM debian:11

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y --no-install-recommends  \
        vim  \
# Install netstat
        net-tools \
# Install ps 
	procps

RUN apt install -y \
	python3.9 \
	python3.9-distutils \
        wget

# # https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html 
# # Ansible
# RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py &&\
#     python3 get-pip.py &&\

# Комманда сверху выдавала ошибку, и я разбил её на части.
# Возможно из-за того что у меня небыло python3.9-distutils с самого начала.
RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
RUN echo 123 # Запустить докер билд от сюда :)
RUN python3.9 get-pip.py &&    pip3 install ansible

# Не получилось поставить MySQL и я установил MariaDB, она абсолютно одинаковая и взаимозаменяемая, но в тоже время open source.
RUN echo 'export DEBIAN_FRONTEND=noninteractive                                                           \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select trusty'                \n\   
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'                  \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/' \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select '                     \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'                   \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7'             \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select '                       \n\
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'          \n\
                                                                                                          \n\    
# wget http://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb                                          \n\    
wget https://repo.mysql.com/mysql-apt-config_0.7.3-1_all.deb                                              \n\    
apt install -y lsb-release gnupg                                                                          \n\                        
dpkg -i mysql-apt-config_0.7.3-1_all.deb                                                                  \n\                                
apt-get update                                                                                            \n\      
                                                                                                          \n\                                        
# apt-get install -y mysql-server-5.7                                                                     \n\
# Package mysql-server-5.7 is not available ...                                                           \n\      
# However the following packages replace it:                                                              \n\                                
#   mariadb-test mariadb-server-10.5                                                                      \n\ 
apt-get install -y mariadb-server-10.5                                                                    \n\
                                                                                                          \n\
# Next command doesn't work and may need to run it manually                                               \n\    
echo run "service mariadb restart" manually if you plan to use mysql                                      \n\         
' > setup.sh
RUN bash -x setup.sh

# After installing MySQL it complains about some package.
# Instead of properly fixing it, i made this hack and it worked.
RUN wget -qO - https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | apt-key add -

WORKDIR /root
CMD /usr/bin/bash
