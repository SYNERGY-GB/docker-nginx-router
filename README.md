
Confd with etcd and Nginx
===============

This image watch an etcd directory (/web-app) and given the keys in it configures a nginx service.

The environment variables used in the template are:

  NOTFOUND_URL
  -----------
   Page to redirect the request when the server name


  ENDPOINT
  -----------
   The username and this env variable conform the server name
   It is the server DNS.


