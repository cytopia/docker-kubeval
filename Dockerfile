FROM alpine:3.13 as builder

RUN set -x \
	&& apk add --no-cache \
		wget

ARG VERSION
RUN set -x \
	&& if [ "${VERSION}" = "latest" ]; then \
		wget "https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz"; \
	else \
		wget "https://github.com/instrumenta/kubeval/releases/download/${VERSION}/kubeval-darwin-amd64.tar.gz"; \
	fi \
	&& tar xf kubeval-linux-amd64.tar.gz \
	&& cp kubeval /usr/bin/kubeval \
	&& chmod +x /usr/bin/kubeval \
	&& kubeval --version


FROM alpine:3.13 as production
ARG VERSION
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#LABEL "org.opencontainers.image.created"=""
#LABEL "org.opencontainers.image.version"=""
#LABEL "org.opencontainers.image.revision"=""
LABEL "maintainer"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.authors"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.vendor"="cytopia"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.url"="https://github.com/cytopia/docker-kubeval"
LABEL "org.opencontainers.image.documentation"="https://github.com/cytopia/docker-kubeval"
LABEL "org.opencontainers.image.source"="https://github.com/cytopia/docker-kubeval"
LABEL "org.opencontainers.image.ref.name"="kubeval ${VERSION}"
LABEL "org.opencontainers.image.title"="kubeval ${VERSION}"
LABEL "org.opencontainers.image.description"="kubeval ${VERSION}"

COPY --from=builder /usr/bin/kubeval /usr/bin/kubeval
WORKDIR /data
ENTRYPOINT ["kubeval"]
CMD ["--version"]
