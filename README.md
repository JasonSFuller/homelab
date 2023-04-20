# homelab

> :orange_book: **IMPORTANT**
>
> This is my personal homelab setup.  Consider it a constant work in progress.
> [Here be dragons](https://en.wikipedia.org/wiki/Here_be_dragons), hazardous
> materials, falling objects, voided warranties, [cats and dogs living
> together... mass hysteria](https://youtu.be/9S4cldkdCjE?t=147)!
>
> You have been warned.



## Mount the Synology "Homelab" NFS share

```shell
sudo yum -y install nfs-utils
sudo install -o jfuller -g root -m 0775 -d /nfs/homelab
sudo cp -a /etc/fstab{,.$(date +%Y%m%d%H%M%S)}
echo '10.0.0.3:/volume6/Homelab /nfs/homelab nfs defaults 0 0' \
  | sudo tee -a /etc/fstab
sudo mount /nfs/homelab
```
