FROM ubuntu:20.04
MAINTAINER jlj7@protonmail.com

# Environment
ENV DEBIAN_FRONTEND noninteractive

# System update
RUN apt-get update && apt-get -y upgrade

# Ruby-related packages for td-agent
RUN apt-get -y install curl libcurl4-openssl-dev ruby ruby-dev make

# Install td-agent v4
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-focal-td-agent4.sh | sh

# Clean cache files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install fluentd plugins
RUN /opt/td-agent/embedded/bin/fluent-gem install --no-document \
  fluent-gem install fluent-plugin-splunk-enterprise

# Add conf
ADD ./etc/fluentd /etc/fluentd

CMD /etc/init.d/td-agent stop && /opt/td-agent/embedded/bin/fluentd -c /etc/fluentd/fluent.conf
