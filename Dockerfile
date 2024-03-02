ARG BUILD_PLATFORM="linux/amd64"
ARG BUILDER_IMAGE="golang:1.21.6-alpine3.18"

FROM --platform=$BUILD_PLATFORM $BUILDER_IMAGE as builder

WORKDIR /
COPY . ./

# Get Signer plugin binary
RUN apk add git make
RUN git clone https://github.com/venafi/notation-venafi-csp.git
WORKDIR /notation-venafi-csp
RUN git fetch --all --tags
RUN git checkout tags/$(git describe --tags $(git rev-list --tags --max-count=1))
RUN make build
WORKDIR /

# Build Go binary
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o kyverno-notation-venafi .

FROM gcr.io/distroless/static:nonroot
WORKDIR /

# Notation home
ENV PLUGINS_DIR=/plugins

COPY --from=builder notation-venafi-csp/bin/notation-venafi-csp plugins/venafi-csp/notation-venafi-csp

COPY --from=builder kyverno-notation-venafi kyverno-notation-venafi
ENTRYPOINT ["/kyverno-notation-venafi"]
