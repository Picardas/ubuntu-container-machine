FROM ubuntu:latest

ENV container=container

RUN apt-get update && \
    apt-get install -y \
    dbus systemd openssh-server net-tools iproute2 iputils-ping curl wget vim-tiny man sudo unminimize && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    yes | unminimize

RUN apt-get update && \
    apt-get install -y git netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

RUN touch /etc/container-machine

RUN >/etc/machine-id
RUN >/var/lib/dbus/machine-id

RUN systemctl set-default multi-user.target
RUN systemctl mask \
      dev-hugepages.mount \
      sys-fs-fuse-connections.mount \
      systemd-update-utmp.service \
      systemd-tmpfiles-setup.service \
      console-getty.service

# start sshd at boot so /run/sshd exists (tmpfiles-setup, which normally creates it, is masked)
RUN systemctl enable ssh.service

RUN sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config

RUN printf 'SetEnv SSH_AUTH_SOCK=/var/host-services/ssh-auth.sock\n' > /etc/ssh/sshd_config.d/10-host-agent.conf
