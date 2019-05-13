FROM       ubuntu:18.04
MAINTAINER xinshu

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt-get update
 
# ssh
RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh

# anaconda
RUN apt-get install -y wget bzip2 && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh && \
    /bin/bash Anaconda3-4.4.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Anaconda3-4.4.0-Linux-x86_64.sh && \
    echo "export PATH=/opt/conda/bin:$PATH" > /etc/profile.d/conda.sh
    
ENV PATH /opt/conda/bin:$PATH
RUN pip install --upgrade pip

# prophet
RUN apt-get install -y g++ && \
    mkdir ~/.pip && \
    echo "[global]" > ~/.pip/pip.conf && \
    echo "index-url = http://mirrors.aliyun.com/pypi/simple/" >> ~/.pip/pip.conf && \
    echo "[install]" >> ~/.pip/pip.conf && \
    echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf && \
    pip install pystan==2.18.0.0 fbprophet==0.4.post2 tensorflow==1.3.0 keras==2.0.8 lightgbm==2.2.2

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
