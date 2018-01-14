FROM bodicsek/alpine-armhf:edge

LABEL Description="Namecheap dynamic dns client"

RUN apk --no-cache add bash bind-tools

COPY docker-entrypoint.sh /
COPY update-ip.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/update-ip.sh"]
