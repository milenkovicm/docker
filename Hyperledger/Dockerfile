FROM yeasy/hyperledger-peer:latest

ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034
# docker
RUN curl -sSL https://get.docker.com | sh
# fetch DIND script
RUN curl -sSL https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind -o /usr/local/bin/dind \
    && chmod a+x /usr/local/bin/dind

COPY ./wrapper.sh /usr/local/bin/wrapper.sh
RUN chmod a+x /usr/local/bin/wrapper.sh

RUN PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:$PATH
WORKDIR $GOPATH/src/github.com/hyperledger/fabric

#peer node start
CMD ["peer","node","start"]
