# [homelab]

[homelab]: https://github.com/JasonSFuller/homelab

> [!WARNING]
> This is my personal homelab setup.  Consider it the Everlasting Gobstopper of
> work in progress.  [Here be dragons], hazardous materials, falling objects,
> voided warranties, [cats and dogs living together... mass hysteria]!
>
> You have been warned.

[here be dragons]: https://en.wikipedia.org/wiki/Here_be_dragons
[cats and dogs living together... mass hysteria]: https://youtu.be/9S4cldkdCjE?t=147

## Mount the Synology "Homelab" NFS share

```shell
sudo yum -y install nfs-utils
sudo install -o jfuller -g root -m 0775 -d /nfs/homelab
sudo cp -a /etc/fstab{,.$(date +%Y%m%d%H%M%S)}
echo '10.0.0.3:/volume6/Homelab /nfs/homelab nfs defaults 0 0' \
  | sudo tee -a /etc/fstab
sudo mount /nfs/homelab
```
