FROM alpine:3.9

ARG GIT_BRANCH
ARG GIT_COMMIT_ID
ARG GIT_DIRTY
ARG GIT_BUILD_TIME
ARG TRAVIS_BUILD_NUMBER
ARG TRAVIS_BUILD_WEB_URL

LABEL git.branch=${GIT_BRANCH}
LABEL git.commit.id=${GIT_COMMIT_ID}
LABEL git.dirty=${GIT_DIRTY}
LABEL git.build.time=${GIT_BUILD_TIME}
LABEL travis.build.number=${TRAVIS_BUILD_NUMBER}
LABEL travis.build.web.url=${TRAVIS_BUILD_WEB_URL}

RUN apk --no-cache add jq=1.6-r0 openssl=1.1.1d-r0

EXPOSE 1194/UDP

VOLUME /srv/nuvlabox/shared

WORKDIR /opt/nuvlabox/

COPY code/ /opt/nuvlabox/

ENTRYPOINT ["/opt/nuvlabox/nuvlabox-openvpn.sh"]

CMD ["--config", "/etc/openvpn/openvpn.conf"]

