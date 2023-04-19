# CoreDNS

Run a CoreDNS container for DNS service in my home lab.

- runs in a container, via `podman`
- live reload configs after saving (both `Corefile` and zones)
- zones created for .home and .corp TLDs (which are [safe to
  use privately](https://www.icann.org/en/board-activities-and-meetings/materials/approved-board-resolutions-regular-meeting-of-the-icann-board-04-02-2018-en#2.c))



## One-time setup

Clone this repo as a regular, non-root user, and find the CoreDNS directory.

```shell
mkdir ~/src
git clone git@github.com:JasonSFuller/homelab.git ~/src/homelab
cd ~/src/homelab/containers/coredns/
```

Build the image.

```shell
sudo podman build . -t coredns
```

Launch the service.

```shell
sudo podman run -d \
  --volume "${PWD}/data:/etc/coredns:Z" \
  --publish 53:53/tcp \
  --publish 53:53/udp \
  --restart always \
  --name coredns \
  localhost/coredns
```

Allow DNS traffic through the firewall.

```shell
sudo firewall-cmd --permanent --add-service=dns
sudo firewall-cmd --reload
```

Enable the podman-restart service.

```shell
sudo systemctl enable podman-restart.service
```

> :orange_book: **IMPORTANT** -- Podman's daemon-less architecture is a key
> difference separating it from Docker, so after a reboot, `--restart always`
> won't work as expected without the `podman-restart` helper service.
>
> _Alternatively_, if you don't want to enable `podman-restart` or need finer
> control, install a systemd config and adjust to your preferences:
>
> ```shell
> sudo install -o root -g root -m 0644 \
>   <(podman generate systemd --new --name coredns)
>   /etc/systemd/system/container-coredns.service
> sudo systemctl edit container-coredns.service
> ```

## Operation

Stop the service.

```shell
sudo podman stop coredns
```

Start the service.

```shell
sudo podman start coredns
```

Modify the CoreDNS config file.

```shell
vim data/Corefile
```

Modify the .home TLD zone.

```shell
vim data/home.zone
```



## Troubleshooting

Send a test DNS query for the default `home.` record.

```console
[jfuller@lab1 ~]# dig home. @localhost +short
lab1.home.
10.0.0.21
```

Open a shell in the container.

```shell
sudo podman exec -it coredns bash
```

View the logs (streaming w/ `-f`).

```shell
sudo podman logs -f coredns
```
