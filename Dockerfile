ARG TAMAGO_VERSION=1.18

FROM golang:$TAMAGO_VERSION as tamago_go

ARG TAMAGO_VERSION
RUN curl -L https://github.com/f-secure-foundry/tamago-go/releases/download/tamago-go${TAMAGO_VERSION}/tamago-go${TAMAGO_VERSION}.linux-amd64.tar.gz | tar -zxf - -C /
RUN ls -l /usr/local/tamago-go

FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

COPY --from=tamago_go /usr/local/tamago-go /usr/local/go
ENV TAMAGO=/usr/local/go
ENV PATH=$PATH:/usr/local/go/bin

RUN go install -v golang.org/x/tools/gopls@latest

ENV GOOS=tamago
ENV GOARCH=arm
