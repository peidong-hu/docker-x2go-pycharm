FROM ubuntu
MAINTAINER Peidong Hu

# Please change this value to force the builders at Quay.io/Docker Hub
# to omit the cached Docker images. This will have the same effect to
# adding `--no-cache` to `docker build` command.
#
ENV DOCKERFILE_UPDATED 2017-04-02

RUN (apt-get update && \
     apt-get install -y software-properties-common && \
     add-apt-repository -y ppa:x2go/stable && \
     apt-get update && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y \
         x2goserver x2goserver-xsession ttf-dejavu fonts-ipafont-gothic \
         openbox obconf obmenu conky nitrogen \
         sudo rxvt-unicode-256color \
         firefox emacs)

RUN (mkdir -p /var/run/sshd && \
     sed -ri 's/UseDNS yes/#UseDNS yes/g' /etc/ssh/sshd_config && \
     echo "UseDNS no" >> /etc/ssh/sshd_config)
#     sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
#     sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config)

# Create a user
RUN (useradd -m docker && \
     mkdir -p /home/docker/.ssh && \
     chmod 700 /home/docker/.ssh && \
     chown docker:docker /home/docker/.ssh && \
     mkdir -p /etc/sudoers.d)

ADD ./999-sudoers-docker /etc/sudoers.d/999-sudoers-docker
RUN chmod 440 /etc/sudoers.d/999-sudoers-docker

# Startup script
ADD ./start-sshd.sh /start-sshd.sh
RUN chmod 744 /start-sshd.sh
RUN chown docker:root /start-sshd.sh

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y \
  python python-dev python-setuptools python-pip \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client curl \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer

ARG pycharm_source=https://download.jetbrains.com/python/pycharm-community-2018.3.4.tar.gz
ARG pycharm_local_dir=.PyCharmCE2018.3

WORKDIR /opt/pycharm

RUN curl -fsSL $pycharm_source -o /opt/pycharm/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz \
  && /usr/bin/python2 /opt/pycharm/helpers/pydev/setup_cython.py build_ext --inplace \
  && /usr/bin/python3 /opt/pycharm/helpers/pydev/setup_cython.py build_ext --inplace
USER docker
ENV HOME /home/docker

RUN mkdir /home/docker/.PyCharm \
  && ln -sf /home/docker/.PyCharm /home/docker/$pycharm_local_dir

#RUN sudo chown docker:root /start-sshd.sh
RUN (sudo apt-get update)
RUN (sudo apt-get install -y xfce4)
RUN (sudo apt-get install -y xfce4-terminal)
RUN (sudo apt-get install -y vim)
RUN (mkdir ~/git)
ADD ./switchShell.sh /home/docker/switchShell.sh
ADD ./switchShell.sh /home/docker/Desktop/switchShell.sh
RUN (sudo pip3 install virtualenv)
RUN (sudo mkdir ~/.virtualenvs)
RUN (sudo pip install virtualenvwrapper)
ENV WORKON_HOME=~/.virtualenvs
RUN (echo ". /usr/local/bin/virtualenvwrapper.sh" >> /home/docker/.bashrc)
ADD ./startPycharm.sh /home/docker/startPycharm.sh
ADD ./startPycharm.sh /home/docker/Desktop/startPycharm.sh

EXPOSE 22
ENTRYPOINT ["/start-sshd.sh"]
