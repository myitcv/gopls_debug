FROM golang:1.13.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
  apt update && \
  apt-get -y install docker-ce && \
  apt-get clean

RUN mkdir /gopls
WORKDIR /gopls

RUN git clone https://github.com/census-instrumentation/opencensus-service && \
  cd /gopls/opencensus-service && \
  git checkout fb16513301ba831e33020eccb21198292402b9d3 && \
  go mod edit -replace=k8s.io/client-go@v2.0.0-alpha.0.0.20181121191925-a47917edff34+incompatible=k8s.io/client-go@a47917edff34 && \
  make agent && \
  mv /go/pkg/mod/cache/download /gocache && \
  rm -rf /go/pkg

ENV GOPROXY file:///gocache

WORKDIR /gopls

RUN curl -LSso docker-compose https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-Linux-x86_64
RUN chmod +x docker-compose

COPY *.yaml /gopls/
COPY run.sh /gopls/

# oc-agent
EXPOSE 55678
# jaeger
EXPOSE 16686
# grafana
EXPOSE 3000

ENTRYPOINT ["/gopls/run.sh"]

