ARG BUILD_PLATFORM="linux/amd64"
ARG BUILDER_IMAGE="golang:1.20.6-alpine3.18"

FROM --platform=$BUILD_PLATFORM $BUILDER_IMAGE as builder

WORKDIR /
COPY . ./

# Build Go binary
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o kyverno-notation-venafi .

FROM gcr.io/distroless/static:nonroot
WORKDIR /

# Notation home
ENV PLUGINS_DIR=/plugins

COPY --from=builder notation-venafi-csp plugins/venafi-csp/notation-venafi-csp

COPY --from=builder kyverno-notation-venafi kyverno-notation-venafi
ENTRYPOINT ["/kyverno-notation-venafi"]
