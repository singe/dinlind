FROM golang as builder
RUN go get -v -u -ldflags "-linkmode external -extldflags -static" github.com/linuxkit/linuxkit/src/cmd/linuxkit

FROM alpine:edge
LABEL maintainer="@singe at SensePost <research@sensepost.com>"
RUN apk update && apk add \
    alpine-baselayout \
    busybox \
    libarchive-tools \
    qemu-img && \
    case $(uname -m) in \
    x86_64) \
        apk add qemu-system-x86_64 ovmf; \
        ;; \
    aarch64) \
        apk add qemu-system-aarch64; \
        ;; \
    s390x) \
        apk add qemu-system-s390x; \
        ;; \
    esac
COPY --from=builder /go/bin/linuxkit /usr/local/bin/
COPY docker-kernel docker-cmdline docker-initrd.img /
ENTRYPOINT [ "/usr/local/bin/linuxkit", "run", "docker" ]
