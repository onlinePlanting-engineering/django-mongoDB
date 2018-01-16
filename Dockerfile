- [参考文档]: https://hub.docker.com/r/centos/python-35-centos7/
- [参考文档]: https://hub.docker.com/r/miticojo/centos7-python3/~/dockerfile/
- [参考文档]: https://ehlxr.me/2017/01/07/CentOS-7-%E5%AE%89%E8%A3%85-Python3%E3%80%81pip3/

- Centos 7安装docker
- [python升级之后遇到的坑]: http://debugrun.weweapp.com/a/tISz5N2.html

    setenforce 0
    systemctl stop firewalld & systemctl disable firewalld
    wget -qO- https://get.docker.com/ | sh
    service docker start
    systemctl enable docker.service #开机启动

    FROM centos:7
    MAINTAINER Alex Li <lixiaobo@cn.ibm.com>
    
    # set python version to install
    ARG PYTHON_VER=3.6.0
    ENV PYTHON_URL=https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz
    
    # install minimum requirements to compile, run compilation, install pip and virtualenv, finally clean used files
    RUN yum install -y gcc make openssl-devel \
      && curl $PYTHON_URL | tar -xzf -  -C /usr/src/ \
      && cd /usr/src/Python-$PYTHON_VER \
      && ./configure --prefix=/usr/local/python3 && make && make install \
      && ln -s /usr/local/python3/bin/python3 /usr/bin/python3 \
      && mv /usr/bin/python /usr/bin/python.bak \
      && ln -s /usr/local/python3/bin/python3 /usr/bin/python \
      && sed -i 's/python/python2.7/g' /usr/bin/yum
    
    RUN sed -i 's/python/python2.7/g' /usr/libexec/urlgrabber-ext-down
    
    RUN cd \ 
      && yum -y install wget \
      && wget --no-check-certificate https://github.com/pypa/pip/archive/9.0.1.tar.gz \
      && chmod 777 9.0.1.tar.gz && tar -zvxf 9.0.1.tar.gz && cd pip-9.0.1 \
      && python3 setup.py install \
      && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip
    
    RUN rm -rf /var/cache/apk/* && rm -rf /usr/src/Python-*
    
    ADD django-mongoDB /opt/django-mongoDB
    
    ADD start.sh /opt/start.sh
    
    RUN pip install --user virtualenv
    
    RUN cd /opt \
      && python -m virtualenv env && source ./env/bin/activate \
      && pip install django djangorestframework mongoengine django-rest-framework-mongoengine virtualenv
     
    EXPOSE 8090
    
    CMD ["/opt/start.sh"]
    

    #!/bin/bash
    cd /opt
    source ./env/bin/activate
    cd /opt/django-mongoDB
    python manage.py runserver 0.0.0.0:8090 # 一定要前台程序，否则container会退出


