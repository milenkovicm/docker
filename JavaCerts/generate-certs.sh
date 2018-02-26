#!/bin/bash

# References:
# https://github.com/trastle/docker-kafka-ssl/blob/master/generate-docker-kafka-ssl-certs.sh
# https://github.com/paulczar/omgwtfssl/blob/master/generate-certs

export CA_SUBJECT=${CA_SUBJECT:-"/C=NA/S=None/L=None/O=None/OU=None/CN=self_signed"}
export CA_EXPIRE=${CA_EXPIRE:-"365"}
export CA_KEY=${CA_KEY:-"ca-key"}
export CA_PUBLIC_KEY=${CA_PUBLIC_KEY:-"ca-cert"}
export CA_KEY_SIZE=${CA_KEY_SIZE:-"2048"}
export CA_PASSWORD=${CA_PASSWORD:-"ca_change_me"}

export KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-"change_me"}
export KEYSTORE_JKS=${KEYSTORE_JKS:-"keystore.jks"}
export KEYSTORE_P12=${KEYSTORE_P12:-"keystore.p12"}
export KEYSTORE_PEM=${KEYSTORE_PEM:-"keystore.pem"}
export KEYSTORE_DNAME=${KEYSTORE_DNAME:-"CN=localhost, OU=None, O=None, L=None, S=None, C=NA"}
export KEYSTORE_ALIAS=${KEYSTORE_ALIAS:-"localhost"}
export KEYSTORE_ALG=${KEYSTORE_ALG:-"RSA"}
export KEYSTORE_KEYSIZE=${KEYSTORE_KEYSIZE:-"2048"}

export TRUSTSTORE_JKS=${TRUSTSTORE_JKS:-"truststore.jks"}

echo "Generating new certs ..."

keytool -keystore $KEYSTORE_JKS -alias $KEYSTORE_ALIAS -validity $CA_EXPIRE -genkey -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD \
  -dname "$KEYSTORE_DNAME" -deststoretype pkcs12 -keyalg $KEYSTORE_ALG -keysize $KEYSTORE_KEYSIZE

if [[ -e ./${CA_KEY} ]]; then
     echo "Using existing CA Key ${CA_KEY}"
else
    echo "Generating new CA Key ${CA_KEY}"
    openssl req -new -x509 -keyout ${CA_KEY} -out $CA_PUBLIC_KEY -days $CA_EXPIRE -passout pass:$CA_PASSWORD \
      -subj "$CA_SUBJECT"
fi

keytool -keystore $TRUSTSTORE_JKS -alias CARoot -import -file $CA_PUBLIC_KEY -storepass $KEYSTORE_PASSWORD -noprompt -deststoretype pkcs12
keytool -keystore $KEYSTORE_JKS -alias $KEYSTORE_ALIAS -certreq -file cert-file -storepass $KEYSTORE_PASSWORD -noprompt -deststoretype pkcs12

openssl x509 -req -CA $CA_PUBLIC_KEY -CAkey ${CA_KEY} -in cert-file -out cert-signed -days $CA_EXPIRE -CAcreateserial -passin pass:$CA_PASSWORD

keytool -keystore $KEYSTORE_JKS -alias CARoot -import -file $CA_PUBLIC_KEY -storepass $KEYSTORE_PASSWORD -noprompt -deststoretype pkcs12
keytool -keystore $KEYSTORE_JKS -alias $KEYSTORE_ALIAS -import -file cert-signed -storepass $KEYSTORE_PASSWORD -noprompt -deststoretype pkcs12

keytool -importkeystore -srckeystore $KEYSTORE_JKS -destkeystore $KEYSTORE_P12 -srcstoretype JKS -deststoretype PKCS12 -srcstorepass $KEYSTORE_PASSWORD \
  -deststorepass $KEYSTORE_PASSWORD -noprompt -deststoretype pkcs12

openssl pkcs12 -in $KEYSTORE_P12 -out $KEYSTORE_PEM -nodes -passin pass:$KEYSTORE_PASSWORD

echo "Generating new certs ... DONE"

