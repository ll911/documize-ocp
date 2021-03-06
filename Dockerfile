FROM alpine:3.12
MAINTAINER leo.lou@gov.bc.ca

ARG DISTBIN="https://documize.s3-eu-west-1.amazonaws.com/downloads/documize-community-linux-amd64"
#ARG DISTBIN="https://github.com/documize/community/releases/download/v3.7.0/documize-community-linux-amd64"

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN apk update \
 && apk --no-cache add git openssh-client \
 && apk --no-cache add --virtual devs tar curl \
 && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o /usr/bin/documize \
      ${DISTBIN} \
 && chmod 0755 /usr/bin/documize \
 && chmod 0755 /usr/bin/entrypoint.sh

WORKDIR /app
RUN adduser -S app \
  && chown -R app:0 /app && chmod -R 770 /app \
  && apk del --purge devs  

USER app
EXPOSE 5001
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
