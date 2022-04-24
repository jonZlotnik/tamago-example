ARG TAMAGO_VERSION=1.18

FROM golang:$TAMAGO_VERSION as tamago_go

ARG TAMAGO_VERSION
RUN curl -L https://github.com/f-secure-foundry/tamago-go/releases/download/tamago-go${TAMAGO_VERSION}/tamago-go${TAMAGO_VERSION}.linux-amd64.tar.gz | tar -zxf - -C /
RUN ls -l /usr/local/tamago-go

FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

RUN apt-get update
RUN apt-get install -y build-essential

COPY --from=tamago_go /usr/local/tamago-go /usr/local/go
ENV TAMAGO=/usr/local/go/bin/go
ENV PATH=$PATH:/usr/local/go/bin

RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v github.com/ramya-rao-a/go-outline@latest
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest
RUN go install -v honnef.co/go/tools/cmd/staticcheck@latest

ENV GOOS=tamago
ENV GOARCH=arm
