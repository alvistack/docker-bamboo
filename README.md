# Docker Image Packaging for Atlassian Bamboo

<a href="https://alvistack.com" title="AlviStack" target="_blank"><img src="/alvistack.svg" height="75" alt="AlviStack"></a>

[![GitLab pipeline status](https://img.shields.io/gitlab/pipeline/alvistack/docker-bamboo/master)](https://gitlab.com/alvistack/docker-bamboo/-/pipelines)
[![GitHub tag](https://img.shields.io/github/tag/alvistack/docker-bamboo.svg)](https://github.com/alvistack/docker-bamboo/tags)
[![GitHub license](https://img.shields.io/github/license/alvistack/docker-bamboo.svg)](https://github.com/alvistack/docker-bamboo/blob/master/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/alvistack/bamboo-9.2.svg)](https://hub.docker.com/r/alvistack/bamboo-9.2)

Bamboo is a continuous integration (CI) server that can be used to automate the release management for a software application, creating a continuous delivery pipeline.

Learn more about Bamboo: <https://www.atlassian.com/software/bamboo>

## Supported Tags and Respective Packer Template Links

-   [`alvistack/bamboo-9.2`](https://hub.docker.com/r/alvistack/bamboo-9.2)
    -   [`packer/docker-9.2/packer.json`](https://github.com/alvistack/docker-bamboo/blob/master/packer/docker-9.2/packer.json)
-   [`alvistack/bamboo-9.1`](https://hub.docker.com/r/alvistack/bamboo-9.1)
    -   [`packer/docker-9.1/packer.json`](https://github.com/alvistack/docker-bamboo/blob/master/packer/docker-9.1/packer.json)
-   [`alvistack/bamboo-8.2`](https://hub.docker.com/r/alvistack/bamboo-8.2)
    -   [`packer/docker-8.2/packer.json`](https://github.com/alvistack/docker-bamboo/blob/master/packer/docker-8.2/packer.json)

## Overview

This Docker container makes it easy to get an instance of Bamboo up and running.

Based on [Official Ubuntu Docker Image](https://hub.docker.com/_/ubuntu/) with some minor hack:

-   Packaging by Packer Docker builder and Ansible provisioner in single layer
-   Handle `ENTRYPOINT` with [catatonit](https://github.com/openSUSE/catatonit)

### Quick Start

For the `BAMBOO_HOME` directory that is used to store the repository data (amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or via a named volume if using a docker version \>= 1.9.

Volume permission is NOT managed by entry scripts. To get started you can use a data volume, or named volumes.

Start Atlassian Bamboo Server:

    # Pull latest image
    docker pull alvistack/bamboo-9.2

    # Run as detach
    docker run \
        -itd \
        --name bamboo \
        --publish 8085:8085 \
        --volume /var/atlassian/application-data/bamboo:/var/atlassian/application-data/bamboo \
        --privileged \
        alvistack/bamboo-9.2

**Success**. Bamboo is now available on <http://localhost:8085>

Please ensure your container has the necessary resources allocated to it. We recommend 2GiB of memory allocated to accommodate both the application server and the git processes. See [Supported Platforms](https://confluence.atlassian.com/display/Bamboo/Supported+Platforms) for further information.

### Run as Remote Agent

Simply running this image as Bamboo Remote Agent, by directly specify the path of the required JAR file.

This is because image already coming with dependencies that required for running Bamboo Server or Remote Agent, therefore the Remote Agent JAR could also be found from:

-   /opt/atlassian/bamboo/atlassian-bamboo/admin/agent/atlassian-bamboo-agent-installer-X.Y.Z.jar
-   /opt/atlassian/bamboo/atlassian-bamboo/admin/agent/bamboo-agent-X.Y.Z.jar

Start Atlassian Bamboo Remote Agent:

    # Run as detach
    docker run \
        -itd \
        --name bamboo \
        --publish 8085:8085 \
        --volume /var/atlassian/application-data/bamboo:/var/atlassian/application-data/bamboo \
        --privileged \
        alvistack/bamboo-9.2 \
        java -jar /opt/atlassian/bamboo/atlassian-bamboo/admin/agent/atlassian-bamboo-agent-installer-X.Y.Z.jar http://bamboo-host-server:8085/bamboo/agentServer/

### Run Build with Podman

Podman installed together with this image, so you could run build independently with Podman, rather than mess up this image by forking it and keep adding your required library support into Dockerfile. Bamboo will auto detect the `docker` binary installed for you (which work as a wrapper to `podman`), so no additional configuration is required.

In the above quick start example, following lines did the magic for your:

    ...
    --privileged \
    ...

## Upgrade

To upgrade to a more recent version of Bamboo Server you can simply stop the Bamboo container and start a new one based on a more recent image:

    docker stop bamboo
    docker rm bamboo
    docker run ... (see above)

As your data is stored in the data volume directory on the host, it will still be available after the upgrade.

Note: Please make sure that you don't accidentally remove the bamboo container and its volumes using the -v option.

## Backup

For evaluations you can use the built-in database that will store its files in the Bamboo Server home directory. In that case it is sufficient to create a backup archive of the directory on the host that is used as a volume (`/var/atlassian/application-data/bamboo` in the example above).

## Versioning

### `YYYYMMDD.Y.Z`

Release tags could be find from [GitHub Release](https://github.com/alvistack/docker-bamboo/tags) of this repository. Thus using these tags will ensure you are running the most up to date stable version of this image.

### `YYYYMMDD.0.0`

Version tags ended with `.0.0` are rolling release rebuild by [GitLab pipeline](https://gitlab.com/alvistack/docker-bamboo/-/pipelines) in weekly basis. Thus using these tags will ensure you are running the latest packages provided by the base image project.

## License

-   Code released under [Apache License 2.0](LICENSE)
-   Docs released under [CC BY 4.0](http://creativecommons.org/licenses/by/4.0/)

## Author Information

-   Wong Hoi Sing Edison
    -   <https://twitter.com/hswong3i>
    -   <https://github.com/hswong3i>
