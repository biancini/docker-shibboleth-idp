docker-shibboleth-idp
=====================

Simple project that implements a Shibbolethj IdP.

Creates a Shibboleth IdP.

Build

* `docker build -t shibboleth-idp .`
* `docker run -i -t shibboleth-idp`

Note: The `sshkey` and `sshkey.pub` are just for example.  Replace with your own
before using.  These are used to access the SSH daemon on the container.

Note: Add, to the Dockerfile, this line to install packets without questions:

* `ENV DEBIAN_FRONTEND noninteractived`

Ports

* 22 (ssh)
* 443 (https)
* 8443 (alternate https)
