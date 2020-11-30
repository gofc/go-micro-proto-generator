GO_PATH=`go env GOPATH`
current_dir = $(shell pwd)

build-docker-image:
	docker build -t goforcloud/go-micro-proto-generator:1.0.0 .

push-docker-image:
	docker push goforcloud/go-micro-proto-generator:1.0.0

gen:
	docker run -it --rm -v ${current_dir}:/workspace goforcloud/go-micro-proto-generator:1.0.0 make gen-proto

gen-proto:
	protoc -I/usr/local/include -I. \
		--go_out ./ --go_opt paths=source_relative \
		--go-grpc_out ./ --go-grpc_opt paths=source_relative \
		--grpc-gateway_out ./ --grpc-gateway_opt logtostderr=true --grpc-gateway_opt paths=source_relative \
		--openapiv2_out ./ --openapiv2_opt logtostderr=true \
		./examples/echo.proto

	@#protoc -I/usr/local/include -I. -I${GO_PATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
#		--go_out=plugins=grpc,paths=source_relative:. \
#		--swagger_out=logtostderr=true,json_names_for_fields=true:./docs/swagger \
#		--grpc-gateway_out=logtostderr=true,paths=source_relative:. $(1)
