# CD の代わりに WORKDIR 使う!
# centos 
FROM centos:centos7

RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install \ 
           kernel-devel \
           kernel-headers \
           gcc-c++ \
           patch \
           libyaml-devel \
           libffi-devel \
           autoconf \
           automake \
           make \
           libtool \
           bison \
           tk-devel \
           zip \
           wget \
           tar \
           gcc \
           zlib \
           zlib-devel \
           bzip2 \
           bzip2-devel \
           readline \
           readline-devel \
           sqlite \
           sqlite-devel \
           openssl \
           openssl-devel \
           git \
           gdbm-devel \
           python-devel \
           vim-enhanced \
           mysql \
           mysql-devel \
           mysql-server \
           mysql-utilities

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

# Python管理用に pyenvを入れる
RUN git clone https://github.com/yyuu/pyenv.git $HOME/.pyenv

# pyenv用の$PATH
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

RUN echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
RUN source ~/.bash_profile

RUN eval "$(pyenv init -)"
RUN pyenv install 3.7.2
RUN pyenv global 3.7.2

# python -> python2を指してるので リンクを張り直す。
RUN unlink /bin/python
RUN ln -s $PYENV_ROOT/versions/3.7.2/bin/python3 /bin/python

# pipのリンク設定
RUN ln -s $PYENV_ROOT/versions/3.7.2/bin/pip3 /bin/pip

RUN pip install --upgrade pip

WORKDIR /code
# 必要なpipを入れていく
ADD requirements.txt /code/
RUN pip install -r requirements.txt

ENV PATH $PATH:$HOME/.pyenv/versions/3.7.2/bin

WORKDIR /code
CMD ["/bin/bash"]