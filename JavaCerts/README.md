# Auto Keytool

A small docker container which automatically generates keystore and truststore for your java applications.
If not deleted `ca-key` and `ca-cert` will be reused. 

Tested with java 1.8

```bash
docker run -ti -v certs:/certs milenkovicm/autokeytool
```

Inspired by https://github.com/paulczar/omgwtfssl