FROM ubuntu:trusty

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
 && echo 'deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu precise main' > /etc/apt/sources.list.d/ruby-ng.list \
 && apt-get -y -q update \
 && apt-get -y -q install git-core ruby2.1 rubygems ruby-switch \
 && ruby-switch --set ruby2.1 \
 && gem install bundler --no-rdoc --no-ri
