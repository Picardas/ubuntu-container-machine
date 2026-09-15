FROM ubuntu:26.04
ENV container=container

RUN apt-get update && \
    apt-get install -y dbus systemd openssh-server iproute2 iputils-ping curl vim-tiny sudo unminimize && \
    yes | unminimize && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN >/etc/machine-id && >/var/lib/dbus/machine-id
RUN systemctl set-default multi-user.target
RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount \
      systemd-update-utmp.service systemd-tmpfiles-setup.service console-getty.service
