
# ColdFusion

## Starting The Application

Create a ColdFusion instance from the CommandBox image (Recommended)
```
docker-compose up -d cb-fw1
```

Create a ColdFusion instance from the Adobe image
```
docker-compose up -d adobe-fw1
```

Access in browser with:
* Adobe CF App: `localhost:8500`
* CommandBox CF App: `localhost:8501`
* Mailhog: `localhost:8025`

To access the application from a remote server, first port forward with:
```
ssh <user>@<ip> -L 8500:localhost:8500 -L 8501:localhost:8501 -L 8025:localhost:8025
```

**Directory Locations**
* Webroot: `/app`
* Command CF Install: `/usr/local/lib/serverHome`
* Adobe CF Install: `/opt/coldfusion`

## FrameworkOne (FW1)

Github: https://github.com/framework-one/fw1

Docs: https://framework-one.github.io/

### Installation

**Note: This is only necessary if using an FW1 version other than 4.2.0, which comes with this repo!**

To upgrade FW1 or install a version other than 4.2.0 run the following commands:
```
docker-compose exec cb-fw1 bash
cd /

# Install the latest stable version
box install fw1

# Install a specific version
# box install fw1@4.2.0
```

## ColdBox

TODO

# Python

TODO
