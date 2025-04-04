FROM quay.io/llrealm/baseutil:main
MAINTAINER leo.lou@gov.bc.ca

USER 0
#ARG DISTBIN="https://documize.s3-eu-west-1.amazonaws.com/downloads/documize-community-linux-amd64"
ARG DISTBIN="https://github.com/documize/community/releases/download/v5.13.0/documize-community-linux-amd64"

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN apk update \
 && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o /usr/bin/documize \
      ${DISTBIN} \
 && chmod 0755 /usr/bin/documize \
 && chmod 0755 /usr/bin/entrypoint.sh \
 && apk del --purge curl tar git openssh-client wget

USER 1000
EXPOSE 5001
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
