FROM alpine:3.16 as builder

RUN set -eux \
	&& apk add --no-cache \
		coreutils \
		git \
		go \
		make \
		wget

ARG VERSION
RUN set -eux \
	&& git clone https://github.com/instrumenta/kubeval /tmp/kubeval \
	&& cd /tmp/kubeval \
	\
	&& if [ "${VERSION}" = "latest" ]; then \
		GIT_TAG="$( git tag | sort -V | tail -1 )"; \
	else \
		GIT_TAG="$( git tag | grep "${VERSION}" | sort -V | tail -1 )"; \
	fi \
	\
	&& git checkout "${GIT_TAG}" \
	\
	&& GIT_VERSION="$( echo "${GIT_TAG}" | sed 's/v//g' )" \
	&& GIT_COMMIT="$( git rev-parse HEAD )" \
	&& GIT_DATE="$( git show -s --format=%ci "${GIT_COMMIT}" )" \
	\
	&& sed -i'' "s/^\s*version\s*=\s\".*\"\$/version = \"${GIT_VERSION}\"/g"  main.go \
	&& sed -i'' "s/^\s*commit\s*=\s\".*\"\$/commit = \"${GIT_COMMIT}\"/g" main.go \
	&& sed -i'' "s/^\s*date\s*=\s\".*\"\$/date = \"${GIT_DATE}\"/g"       main.go \
	&& grep 'var (' -A 10 main.go \
	\
	&& make build \
	&& mv bin/kubeval /usr/bin/kubeval \
	&& chmod +x /usr/bin/kubeval \
	&& kubeval --version


FROM alpine:3.16 as production
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
