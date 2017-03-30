# Murmur Docker Image

Docker files for Murmur server, a component of [Mumble](https://wiki.mumble.info/wiki/Main_Page). Mumble is a fast and efficient VOIP solution.

## Getting Started

Instructions within are geared toward Linux distributions.

1. Ensure [Docker Compose](https://docs.docker.com/compose/) is installed along with [Docker Engine](https://docs.docker.com/engine/installation/). The included **docker-compose.yml** file uses version 3 so it's possible [an upgrade](https://docs.docker.com/compose/install/#upgrading) of Docker Compose may be required.

2. [Create a Docker network](./README.md#container-network) named `main`.

3. Clone this repository to the folder of your choice.

4. Create the folders `./volume_data/config` and `./volume_data/main`.

5. Copy the config file found at `./config/murmur.ini` to `./volume_data/config`. Edit the file afterward to change desired settings (e.g. server password, etc.). For more details on this file, see the official [Murmurguide](https://wiki.mumble.info/wiki/Murmurguide#Configuring_ini_File).

6. Change the owner of the folders by running `sudo chown -R 1077:1077 ./volume_data`. This allows the **murmur** user account the container runs as to access these folders.

7. Run the command `docker-compose -up -d`.

8. Get the super user password by running `sudo docker logs Murmur 2>&1 | grep Password`.

## Container Network

The network specified (can be changed to the desired value) by this Docker container is named `main`. It is assumed that this network has already been created prior to using the included Docker Compose file. The reason for this is to avoid generating a default network.

If no network has been created, run the following Docker command: `sudo docker network create network-name`. Be sure to replace *network-name* with the name of the desired network. For more information on this command, go [here](https://docs.docker.com/engine/reference/commandline/network_create/).

## Port Mapping

The external port used to map to the internal port that Murmur uses is 51200 (maps to 64738). This can certainly be changed but please be mindful of the effects. Additional configuration may be required as a result.

## Data Volumes

It is possible to change the data volume folders mapped to the Murmur container to something other than `volume_data/x` if desired. It is recommended to choose a naming scheme that is easy to recognize.

## Logrotate Example

In order to properly rotate the logs that Murmur outputs, [logrotate](https://support.rackspace.com/how-to/understanding-logrotate-utility/) can be used. The logs for this container can be found at **/var/lib/docker/containers**.

It is recommended to create a file with logrotate settings for all Docker containers and copy it to **/etc/logrotate.d**. This would rotate all the logs for all Docker containers.

```bash
/var/lib/docker/containers/*/*.log {
  rotate 52
  weekly
  compress
  size=1M
  missingok
  delaycompress
  copytruncate
}
```

## Special Thanks

Special thanks goes to [Matt Kemp](https://github.com/mattikus) for his [Murmur Docker image](https://github.com/mattikus/docker-murmur) that served as an inspiration for this solution.
