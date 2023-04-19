# mirror-www

```shell
# Stop the service
#   podman stop mirror-www
# Start the service
#   podman start mirror-www
# Troubleshooting (access container if running)
#   podman exec -it mirror-www bash
# View logs (streaming w/ `-f`)
#   podman logs -f mirror-www

sudo podman run -d \
  --volume "${PWD}/conf:/etc/nginx/:ro,Z" \
  --volume "${PWD}/data:/usr/share/nginx/html:ro,Z" \
  --publish 80:80/tcp \
  --publish 443:443/tcp \
  --restart always \
  --name mirror-www \
  docker.io/library/nginx:latest

# open firewall
sudo firewall-cmd --permanent --add-service=http --add-service=https
sudo firewall-cmd --reload
```
