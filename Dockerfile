FROM golang:1.15

RUN apt-get update && apt-get install -y unzip

#install protobuf
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protoc-3.14.0-linux-x86_64.zip \
    && unzip protoc-3.14.0-linux-x86_64.zip -d protoc3 \
    && unzip -o protoc-3.14.0-linux-x86_64.zip -d /usr/local bin/protoc \
    && unzip -o protoc-3.14.0-linux-x86_64.zip -d /usr/local 'include/*' \
    && rm -f protoc-3.14.0-linux-x86_64.zip

WORKDIR /download
ADD ./go.* ./

RUN go install \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
    github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
    google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc

ADD ./third_party/googleapis/* /usr/local/include/

WORKDIR /workspace
