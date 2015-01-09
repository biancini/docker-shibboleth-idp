FROM ubuntu:14.04
MAINTAINER voxsim-mala "https://github.com/malavolti/docker-puppetagent"
ENV DEBIAN_FRONTEND noninteractive

# Install puppet agent
#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe multiverse" > /etc/apt/sources.list
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN apt-get update
RUN apt-get install -y wget ruby augeas-tools python-jinja2 git
RUN wget -q https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O /tmp/puppetlabs.deb
RUN dpkg -i /tmp/puppetlabs.deb
RUN apt-get -y install puppet puppetmaster
#ADD puppet.conf /etc/puppet/puppet.conf

# Download IdP in the cloud puppet code
WORKDIR /opt
#RUN git clone https://github.com/ConsortiumGARR/Puppet-GARRShibbolethIdP.git /opt/Puppet-GARRShibbolethIdP
RUN git clone https://github.com/biancini/Puppet-GARRShibbolethIdP.git /opt/Puppet-GARRShibbolethIdP

WORKDIR /opt/Puppet-GARRShibbolethIdP
RUN git submodule init
RUN git submodule update
WORKDIR /opt/Puppet-GARRShibbolethIdP/garr-common
RUN git submodule init
RUN git submodule update

WORKDIR /etc/puppet/modules
RUN for i in /opt/Puppet-GARRShibbolethIdP/puppetlabs/*; do ln -s $i; done
RUN for i in /opt/Puppet-GARRShibbolethIdP/garr-common/garr/*; do ln -s $i; done
RUN for i in /opt/Puppet-GARRShibbolethIdP/garr-common/puppetlabs/*; do ln -s $i; done
RUN for i in /opt/Puppet-GARRShibbolethIdP/garr/*; do ln -s $i; done
#RUN touch /etc/puppet/manifests/site.pp
#RUN mkdir /etc/puppet/manifests/nodes

# Create custom files for IdP and generate site.pp
# execute prepare_puppetmaster.sh to create default keys and files for IdP
WORKDIR /tmp
ADD prepare_puppetmaster.sh /opt/Puppet-GARRShibbolethIdP/scripts/prepare_puppetmaster.sh
RUN /bin/bash /opt/Puppet-GARRShibbolethIdP/scripts/prepare_puppetmaster.sh

# generate_sitepp.py
ADD /tmp/site.pp /etc/puppet/manifests/site.pp

EXPOSE 22
EXPOSE 443
EXPOSE 8443

WORKDIR /root
CMD ["/bin/bash"]
