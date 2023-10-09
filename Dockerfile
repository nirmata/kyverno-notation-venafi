ARG BUILD_PLATFORM="linux/amd64"
ARG BUILDER_IMAGE="golang:1.20.6-alpine3.18"

FROM --platform=$BUILD_PLATFORM $BUILDER_IMAGE as builder

WORKDIR /
COPY . ./

# Get Signer plugin binary
RUN apk add git
RUN apk add make
RUN ls -latr
RUN git clone https://github.com/venafi/notation-venafi-csp.git notation-venafi-csp-repo
RUN ls -latr
RUN git -C notation-venafi-csp-repo fetch --all --tags
RUN git -C notation-venafi-csp-repo checkout tags/v0.2.0-beta 
# RUN git -C notation-venafi-csp-repo checkout tags/$(git describe --tags $(git rev-list --tags --max-count=1))
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build --ldflags="-buildid= -X sigs.k8s.io/release-utils/version.gitVersion= -X sigs.k8s.io/release-utils/version.gitCommit= -X sigs.k8s.io/release-utils/version.gitTreeState= -X sigs.k8s.io/release-utils/version.buildDate=" -o notation-venafi-csp .notation-venafi-csp-repo/cmd/notation-venafi-csp

# Build Go binary
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o kyverno-notation-venafi .

FROM gcr.io/distroless/static:nonroot
WORKDIR /

# Notation home
ENV PLUGINS_DIR=/plugins

COPY --from=builder notation-venafi-csp plugins/venafi-csp/notation-venafi-csp

COPY --from=builder kyverno-notation-venafi kyverno-notation-venafi
ENTRYPOINT ["/kyverno-notation-venafi"]
