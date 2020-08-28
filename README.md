**This Project is still work in progress.**

# UniFi Controller
Super small and easy to set up UniFi Controller.

## Running the server
```bash
docker run --detach --name unifi --publish 8080:8080 --publish 8443:8443 hetsh/unifi
```

## Stopping the container
```bash
docker stop unifi
```

## Configuring
The UniFi Controller is configured via its [web interface](http://localhost:8443).
A configuration wizard will guide you through the initial setup if you run the server for the first time.

## Creating persistent storage
```bash
STORAGE="/path/to/storage"
mkdir -p "$STORAGE"
chown -R 1361:1361 "$STORAGE"
```
`1361` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the storage directory.
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/storage,target=/unifi ...
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly ...
```

## Automate startup and shutdown via systemd
```bash
systemctl enable unifi --now
```
The systemd unit can be found in my [GitHub repository](https://github.com/Hetsh/docker-unifi).
By default, the systemd service assumes `/etc/unifi/app.ini` for config, `/etc/unifi/data` for storage and `/etc/localtime` for timezone.
You need to adjust these to suit your setup.

## Fork Me!
This is an open project hosted on [GitHub](https://github.com/Hetsh/docker-unifi). Please feel free to ask questions, file an issue or contribute to it.
