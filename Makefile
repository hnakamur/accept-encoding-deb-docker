PKG_ARCHIVE_NAME=accept-encoding
PKG_VERSION=0.2.0
DEB_REVISION=2
ifdef NO_CACHE
DOCKER_NO_CACHE=--no-cache
endif

deb: build
	docker run --rm -v ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${DEB_REVISION}:/dist ${PKG_ARCHIVE_NAME} bash -c \
	"install /src/*${PKG_VERSION}* /dist/"

build:
	mkdir -p ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${DEB_REVISION}
	(set -x; \
	docker buildx build --load --progress=plain ${DOCKER_NO_CACHE} \
		--build-arg PKG_VERSION=${PKG_VERSION} \
		--build-arg DEB_REVISION=${DEB_REVISION} \
		-t ${PKG_ARCHIVE_NAME} . \
	) 2>&1 | tee ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${DEB_REVISION}/${PKG_ARCHIVE_NAME}_${PKG_VERSION}-${DEB_REVISION}.build.log && \
	xz -9 --force ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${DEB_REVISION}/${PKG_ARCHIVE_NAME}_${PKG_VERSION}-${DEB_REVISION}.build.log

.PHONY: deb build

exec:
	docker exec -it $$(docker ps -q) bash

.PHONY: exec
