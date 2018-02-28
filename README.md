Docker Image Packaging for Atlassian Bamboo
===========================================

[![Travis](https://img.shields.io/travis/alvistack/docker-bamboo.svg)](https://travis-ci.org/alvistack/docker-bamboo)
[![GitHub release](https://img.shields.io/github/release/alvistack/docker-bamboo.svg)](https://github.com/alvistack/docker-bamboo/releases)
[![GitHub license](https://img.shields.io/github/license/alvistack/docker-bamboo.svg)](https://github.com/alvistack/docker-bamboo/blob/master/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/alvistack/docker-bamboo.svg)](https://hub.docker.com/r/alvistack/docker-bamboo/)

Bamboo is a continuous integration (CI) server that can be used to automate the release management for a software application, creating a continuous delivery pipeline.

Learn more about Bamboo: <https://www.atlassian.com/software/bamboo>

Overview
--------

This Docker container makes it easy to get an instance of Bamboo up and running.

### Quick Start

For the `BAMBOO_HOME` directory that is used to store the repository data (amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or via a named volume if using a docker version &gt;= 1.9.

Volume permission is managed by entry scripts. To get started you can use a data volume, or named volumes.

Start Atlassian Bamboo Server:

    # Pull latest image
    docker pull alvistack/docker-bamboo

    # Run as detach
    docker run \
        -itd \
        --name bamboo \
        --publish 8085:8085 \
        --volume /var/atlassian/application-data/bamboo:/var/atlassian/application-data/bamboo \
        alvistack/docker-bamboo

**Success**. Bamboo is now available on <http://localhost:8085>

Please ensure your container has the necessary resources allocated to it. We recommend 2GiB of memory allocated to accommodate both the application server and the git processes. See [Supported Platforms](https://confluence.atlassian.com/display/Bamboo/Supported+Platforms) for further information.

### Memory / Heap Size

If you need to override Bamboo's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

#### JVM\_MINIMUM\_MEMORY

The minimum heap size of the JVM

Default: `512m`

#### JVM\_MAXIMUM\_MEMORY

The maximum heap size of the JVM

Default: `1024m`

### Reverse Proxy Settings

If Bamboo is run behind a reverse proxy server, then you need to specify extra options to make Bamboo aware of the setup. They can be controlled via the below environment variables.

#### CATALINA\_CONNECTOR\_PROXYNAME

The reverse proxy's fully qualified hostname.

Default: *NONE*

#### CATALINA\_CONNECTOR\_PROXYPORT

The reverse proxy's port number via which Bamboo is accessed.

Default: *NONE*

#### CATALINA\_CONNECTOR\_SCHEME

The protocol via which Bamboo is accessed.

Default: `http`

#### CATALINA\_CONNECTOR\_SECURE

Set 'true' if CATALINA\_CONNECTOR\_SCHEME is 'https'.

Default: `false`

#### CATALINA\_CONTEXT\_PATH

The context path via which Bamboo is accessed.

Default: *NONE*

### JVM configuration

If you need to pass additional JVM arguments to Bamboo such as specifying a custom trust store, you can add them via the below environment variable

#### JVM\_SUPPORT\_RECOMMENDED\_ARGS

Additional JVM arguments for Bamboo

Default: `-Datlassian.plugins.enable.wait=300`

Upgrade
-------

To upgrade to a more recent version of Bamboo Server you can simply stop the Bamboo
container and start a new one based on a more recent image:

    docker stop bamboo
    docker rm bamboo
    docker run ... (see above)

As your data is stored in the data volume directory on the host, it will still
be available after the upgrade.

Note: Please make sure that you don't accidentally remove the bamboo container and its volumes using the -v option.

Backup
------

For evaluations you can use the built-in database that will store its files in the Bamboo Server home directory. In that case it is sufficient to create a backup archive of the directory on the host that is used as a volume (`/var/atlassian/application-data/bamboo` in the example above).

Versioning
----------

The `latest` tag matches the most recent version of this repository. Thus using `alvistack/docker-bamboo:latest` or `alvistack/docker-bamboo` will ensure you are running the most up to date version of this image.

License
-------

-   Code released under [Apache License 2.0](LICENSE)
-   Docs released under [CC BY 4.0](http://creativecommons.org/licenses/by/4.0/)

Author Information
------------------

-   Wong Hoi Sing Edison
    -   <https://twitter.com/hswong3i>
    -   <https://github.com/hswong3i>

