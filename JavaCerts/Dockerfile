FROM openjdk:8-alpine

RUN apk --update add bash openssl

WORKDIR /certs
VOLUME /certs

COPY generate-certs.sh /usr/local/bin/generate-certs.sh
RUN chmod 755 /usr/local/bin/generate-certs.sh

CMD /usr/local/bin/generate-certs.sh

