#Etcd configured nginx application router

This container allows you to easily set up an nginx server that will redirect to the proper application based on
configuration set up with [etcd](https://github.com/coreos/etcd).

The container uses [confd](https://github.com/kelseyhightower/confd) to watch for changes in the configuration and update
the nginx configuration files accordingly.

##Usage

```
docker run -e ETCD_HOST=127.0.0.1 -e ETCD_PREFIX=/applications \
           -e ENDPOINT=synergy-gb.com  -e NOTFOUND_URL=http://synergy-gb.com/404 \
           -v /home/me/tls:/tls \
           synergygb/docker-nginx-router
```

This will start nginx and have confd watch for changes on the locally running etcd (127.0.0.1). It will also use the
TLS certificate and private key available on the host on `/home/me/tls`.

When a user tries to access via http or https the subdomain `my.synergy-gb.com`, the request will be proxied to the host
specified in the value of `/applications/my` on etcd. The request will always be proxied on port 80.

If a user attempts to access a subdomain for which there is no value registered in etcd, it will be redirected to the
URL specified in NOTFOUND_URL.

Adding more keys on etcd will automatically make those subdomains available in the router.

##Configuration Variables

- __ENDPOINT__: FQDN of the aplications' parent domain __(required)__
- __ETCD_HOST__: Host where etcd is running __(required)__
- __ETCD_PORT__: Port where etcd is running. Defaults to 4001
- __ETCD_PREFIX__: Key to watch for changes. Defaults to `/apps`.
- __NOTFOUND_URL__: Page to redirect to when no app with the requested name is registered
- __PROXY_TIMEOUT__: The timeout to wait when reading from proxied servers (this will be set to the `proxy_read_timeout` value of nginx.)
- __UPDATE_INTERVAL__: Interval (in seconds) to wait between confd polls. Defaults to 10
- __TLS__: Enable/Disable TLS support. Defaults to 1 (enabled)
- __TLS_CERT__: Certificate filename. This path is relative to the `/tls` folder. Defaults to `cert.crt`
- __TLS_KEY__: Private key filename. This path is relative to the `/tls` folder. Defaults to `cert.key`

##TLS

The container requires TLS by default. Non-HTTPS request will be automatically redirected to HTTPS.
You must mount on the `/tls` folder a `cert.crt` file (which should be a certificate chain bundle) and a `cert.key`
file which is the certificate's private key. Both should be PEM formatted.

If you wish to disable TLS access set the TLS envvar to 0.
