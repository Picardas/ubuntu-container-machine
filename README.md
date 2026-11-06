# Ubuntu dev machine (Apple `container machine`)

My custom Apple container machine Ubuntu image with systemd init system, git and chezmoi, run with `container machine`.

## Build

Push to `main` (or run the workflow).
Image: `ghcr.io/<username>/ubuntu-machine:latest`.
For private repositories: `container registry login ghcr.io -u <username>`.

## Create and enter

```bash
container system start
container machine create ghcr.io/<username>/ubuntu-machine:latest --name ubuntu
```

To set as the default and run
```bash
container machine set-default ubuntu
container machine run
```

Or to run without setting it as the default
```bash
container m run -n ubuntu
```

## Connect over SSH

The IP address of the Container Machine is set by macOS virtual DHCP client and can't be fixed. Reach the machine with a ProxyCommand, which needs no IP and no network route.

```
Host ubuntu
	User <macuser>
	IdentityFile ~/.ssh/id_ed25519_dev
	IdentitiesOnly yes
	ProxyCommand container machine run -n ubuntu -i --root -- /usr/sbin/sshd -i
```

**One-time key setup:**

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519_dev -C "ContainerMachine"
# inside the machine:
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cat /Users/<macuser>/.ssh/id_ed25519_dev.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Delete

```bash
container machine stop ubuntu
container machine rm ubuntu        # deletes the machine's storage, including /home/<you>
```

## Delete all Apple container containers/images/volumes

```bash
container stop --all
container delete --all --force
container image delete --all
container builder delete --force 2>/dev/null || true
container volume delete --all
container network delete --all
```
