FROM ubuntu:14.04

RUN apt-get update -qq
RUN apt-get install -qq curl git mercurial

# Install Go
RUN curl -Lo /tmp/golang.tgz https://storage.googleapis.com/golang/go1.3.linux-amd64.tar.gz
RUN tar -xzf /tmp/golang.tgz -C /usr/local
ENV GOROOT /usr/local/go
ENV GOBIN /usr/local/bin
ENV PATH /usr/local/go/bin:$PATH
ENV GOPATH /srclib

# TMP: this are slow; pre-fetch for faster builds
RUN go get -d code.google.com/p/go.tools/go/loader

# Allow determining whether we're running in Docker
ENV IN_DOCKER_CONTAINER true

# Add this toolchain
ADD . /srclib/src/github.com/sourcegraph/srclib-go/
WORKDIR /srclib/src/github.com/sourcegraph/srclib-go
RUN go get -v -d
RUN go install

# Now set the GOPATH for the project source code, which is mounted at /src.
ENV GOPATH /
WORKDIR /src

ENTRYPOINT ["srclib-go"]
