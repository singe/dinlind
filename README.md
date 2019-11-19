# Docker in LinuxKit in Docker (dinlind)

Sometimes you need to run [Docker in Docker](https://hub.docker.com/_/docker/), but it not a meaningful security boundary because you need to run a privileged docker container (see [Do Not Use Docker in Docker for CI](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)).

LinuxKit is a nice way to run Docker hosts. It's how Docker Desktop works on macOS and Windows. Fully emulated qemu doesn't need privileges and is supported by LinuxKit. Let's use that to host our Docker in Docker, so we don't need to use privileged containers.

## Usage

Just pull the image from docker hub and run it:
`docker run --rm -it singelet/dinlind`

You'll be dropped into a booting qemu. When it finishes, you can can access the internal docker with:
`chroot /containers/services/docker/rootfs`

Then just run docker as normal.

## Building

If you want to build your own LinuxKit image. Then install LinuxKit as described in [their repository](https://github.com/linuxkit/linuxkit#getting-started), and build the [docker.yml](https://github.com/linuxkit/linuxkit/blob/master/examples/docker.yml) image with:

`linuxkit build -format kernel+initrd docker.yml`

And copy the resulting files to the directory with this Dockerfile. There should be three files:

* docker-kernel
* docker-initrd.img
* docker-cmdline

The rebuild this container.
