# Magento 2 Docker

A collection of Docker images for running Magento 2 through nginx and on the command line.

## Prerequisites

    If your mac doesn't support hyper threading you can use Dinghy the instructions are here https://github.com/codekitchen/dinghy

    Disable Dinghy's proxy
    Go to ~/.dinghy/preferences.yml and set proxy_disabled to true.

    And start Dinghy
    dinghy up
 
    If Dinghy was already started you can kill the built-in proxy
    docker ps --filter name="dinghy_http_proxy" -q | xargs docker rm -f

    Be sure that you have a docker-machine activated
    docker-machine ls

    Otherwise just activate Dinghy
    eval $(dinghy shellinit)

    Point every *.docker request to your docker machine.
    echo $(docker-machine ip $(docker-machine active)) docker >> /etc/hosts

    Create a network called nginx-proxy
    docker network create nginx-proxy

    Start nginx reverse proxy from jwilder/nginx-proxy repository
    docker run -d --network nginx-proxy -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

## Quick Start

    Modify docker-compose.yml and change VHOST_NAME environment variable and M2SETUP_BASE_URL with the url that you want to use for development.

    cp composer.env.sample composer.env
    # ..put the correct tokens into composer.env anyway possible the installation of sample data will ask for them again, keep them visible somewhere.
   
    If you need sample data uncomment the line
    - M2SETUP_USE_SAMPLE_DATA=true
 
    mkdir magento

    docker-compose run cli magento-installer
    docker-compose up -d
    docker-compose restart

## Configuration

Configuration is driven through environment variables.  A comprehensive list of the environment variables used can be found in each `Dockerfile` and the commands in each `bin/` directory.

* `PHP_MEMORY_LIMIT` - The memory limit to be set in the `php.ini`
* `MAGENTO_RUN_MODE` - Valid values, as defined in `Magento\Framework\App\State`: `developer`, `production`, `default`.
* `MAGENTO_ROOT` - The directory to which Magento should be installed (defaults to `/var/www/magento`)
* `COMPOSER_GITHUB_TOKEN` - Your [GitHub OAuth token](https://getcomposer.org/doc/articles/troubleshooting.md#api-rate-limit-and-oauth-tokens), should it be needed
* `COMPOSER_MAGENTO_USERNAME` - Your Magento Connect public authentication key ([how to get](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html))
* `COMPOSER_MAGENTO_PASSWORD` - Your Magento Connect private authentication key
* `DEBUG` - Toggles tracing in the bash commands when exectued; nothing to do with Magento`
* `PHP_ENABLE_XDEBUG` - When set to `true` it will include the Xdebug ini file as part of the PHP configuration, turning it on. It's recommended to only switch this on when you need it as it will slow down the application.
* `UPDATE_UID_GID` - If this is set to "true" then the uid and gid of `www-data` will be modified in the container to match the values on the mounted folders.  This seems to be necessary to work around virtualbox issues on OSX.

A sample `docker-compose.yml` is provided in this repository.

## CLI Usage

A number of commands are baked into the image and are available on the `$PATH`. These are:

* `magento-command` - Provides a user-safe wrapper around the `bin/magento` command.
* `magento-installer` - Installs and configures Magento into the directory defined in the `$MAGENTO_ROOT` environment variable.

It's recommended that you mount an external folder to `/root/.composer/cache`, otherwise you'll be waiting all day for Magento to download every time the container is booted.

CLI commands can be triggered by running:

    docker-compose run cli magento-installer

Shell access to a CLI container can be triggered by running:

    docker-compose run cli bash

## Implementation Notes

* In order to achieve a sane environment for executing commands in, a `docker-environment` script is included as the `ENTRYPOINT` in the container.

## Credits

Thanks to [Mark Shust](https://twitter.com/markshust) for his work on [docker-magento2-php](https://github.com/mageinferno/docker-magento2-php) that was used as a basis for this implementation.  You solved a lot of the problems so I didn't need to!
