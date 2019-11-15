# NuvlaBox Network Manager

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)](https://github.com/nuvlabox/network-manager/graphs/commit-activity)


[![CI](https://img.shields.io/travis/com/nuvlabox/network-manager?style=for-the-badge&logo=travis-ci&logoColor=white)](https://travis-ci.com/nuvlabox/network-manager)
[![GitHub issues](https://img.shields.io/github/issues/nuvlabox/network-manager?style=for-the-badge&logo=github&logoColor=white)](https://GitHub.com/nuvlabox/network-manager/issues/)
[![Docker pulls](https://img.shields.io/docker/pulls/nuvlabox/network-manager?style=for-the-badge&logo=Docker&logoColor=white)](https://cloud.docker.com/u/nuvlabox/repository/docker/nuvlabox/network-manager)
[![Docker image size](https://img.shields.io/microbadger/image-size/nuvlabox/network-manager?style=for-the-badge&logo=Docker&logoColor=white)](https://cloud.docker.com/u/nuvlabox/repository/docker/nuvlabox/network-manager)

![logo](https://uc977612ad25e6fb53ac9275cd4c.previews.dropboxusercontent.com/p/thumb/AAhLDh0-m61kGliju2bmLxVEc36VssSKVjGd9r6JnxmpdVExwfKsZWXtVtc2gz0IR1PN7tviqaJJY3YSXHZhxTwO1x_8bHHt3W49SZDgrMqPW84Jw9vg-Dmv_2J4siLp44GvufcOPr8Rw96xIGfG1JIm_xrADjdl0tpgW8LrJnojoMl5l7hCs0cNLMQm54P_QH8hhg5cc8Nkvk2M5F5YBp4MM5M62AMQXZRihBz4QsbvHeVNIj3Z8lI-gbcY9rYjiQmLYeAdP_REq2eEYcrADrMHHI6oJRuFQAAzrEPcyc6_3KQzMENiGflpKZAE2BcAJAJ956KodJjixpH8PPC_3sGlhijEZ2LTE_jwb00-znmVRV-BYNr8MO16HCZIBQeRgSc/p.png?fv_content=true&size_mode=5)


**This repository contains the source code for the NuvlaBox Network Manager - the microservice that manages all network related configurations (eg: WiFi Access Point, VPN, Firewall) in the [NuvlaBox](https://sixsq.com/products-and-services/nuvlabox/overview).**

This microservice is an integral component of the NuvlaBox Engine.

---

**NOTE:** this microservice is part of a loosely coupled architecture, thus when deployed by itself, it might not provide all of its functionalities. Please refer to https://github.com/nuvlabox/deployment for a fully functional deployment

---

## Build the NuvlaBox Network Manager

This repository is already linked with Travis CI, so with every commit, a new Docker image is released. 

There is a [POM file](pom.xml) which is responsible for handling the multi-architecture and stage-specific builds.

**If you're developing and testing locally in your own machine**, simply run `docker build .` or even deploy the microservice via the local [compose files](docker-compose.yml) to have your changes built into a new Docker image, and saved into your local filesystem.

**If you're developing in a non-master branch**, please push your changes to the respective branch, and wait for Travis CI to finish the automated build. You'll find your Docker image in the [nuvladev](https://hub.docker.com/u/nuvladev) organization in Docker hub, names as _nuvladev/network-manager:\<branch\>_.

## Deploy the NuvlaBox Network Manager


### Prerequisites 

 - *Docker (version 18 or higher)*
 - *Docker Compose (version 1.23.2 or higher)*


### Launching the NuvlaBox Network Manager

Simply run `docker-compose up --build`


## Contributing

This is an open-source project, so all community contributions are more than welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md)
 
## Copyright

Copyright &copy; 2019, SixSq Sàrl
