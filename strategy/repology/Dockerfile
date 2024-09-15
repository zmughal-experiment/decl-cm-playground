ARG DEB_RELEASE="bookworm"

FROM postgres:16-${DEB_RELEASE}

ARG APT_PKGS_DEV="                \
wget ca-certificates              \
postgresql-server-dev-${PG_MAJOR} \
gcc g++ make cmake pkg-config     \
"
ARG APT_PKGS_RUN=" \
tar \
"

ARG LIBVERSION_LIB_VERSION="3.0.3"
ARG LIBVERSION_LIB_SHA256="bb49d745a0c8e692007af6d928046d1ab6b9189f8dbba834cdf3c1d251c94a1d"
ARG LIBVERSION_LIB_TARBALL_URL="https://github.com/repology/libversion/archive/refs/tags/${LIBVERSION_LIB_VERSION}.tar.gz"

ARG LIBVERSION_PGX_VERSION="2.0.1"
ARG LIBVERSION_PGX_SHA256="3d0f0aa277efa075ecbe7c51ee84ac2277870fb0e52404a8331491e12a4073b4"
ARG LIBVERSION_PGX_TARBALL_URL="https://github.com/repology/postgresql-libversion/archive/refs/tags/${LIBVERSION_PGX_VERSION}.tar.gz"

WORKDIR /work

RUN \
	# Install requirements for build {{{ \
	set -eux \
	\
	# via apt-get \
	&& apt-get update && apt-get install -y --no-install-recommends \
		$APT_PKGS_DEV $APT_PKGS_RUN \
	# }}} \
	&& true \
#RUN \
	# LIBVERSION-LIB START {{{ \
	set -eux \
	\
	# Download libversion-lib \
	&& wget -O libversion-${LIBVERSION_LIB_VERSION}.tar.gz $LIBVERSION_LIB_TARBALL_URL \
	&& echo "${LIBVERSION_LIB_SHA256} libversion-${LIBVERSION_LIB_VERSION}.tar.gz" | sha256sum -c - \
	\
	# Extract libversion-lib \
	&& mkdir -p /usr/src/libversion-${LIBVERSION_LIB_VERSION} \
	&& tar xvf \
		libversion-${LIBVERSION_LIB_VERSION}.tar.gz \
		-C /usr/src/libversion-${LIBVERSION_LIB_VERSION} \
		--strip-components=1 \
	\
	# Build libversion-lib \
	&& cd /usr/src/libversion-${LIBVERSION_LIB_VERSION} \
	&& cmake . && cmake --build . \
	&& make install \
	&& ldconfig \
	# LIBVERSION-LIB END }}} \
	&& true \
#RUN \
	# LIBVERSION-PGX START {{{ \
	set -eux \
	\
	# Download libversion-pgx \
	&& wget -O postgresql-libversion-${LIBVERSION_PGX_VERSION}.tar.gz $LIBVERSION_PGX_TARBALL_URL \
	&& echo "${LIBVERSION_PGX_SHA256} postgresql-libversion-${LIBVERSION_PGX_VERSION}.tar.gz" | sha256sum -c - \
	\
	# Extract libversion-pgx \
	&& mkdir -p /usr/src/postgresql-libversion-${LIBVERSION_PGX_VERSION} \
	&& tar xvf \
		postgresql-libversion-${LIBVERSION_PGX_VERSION}.tar.gz \
		-C /usr/src/postgresql-libversion-${LIBVERSION_PGX_VERSION} \
		--strip-components=1 \
	\
	# Build libversion-pgx \
	&& cd /usr/src/postgresql-libversion-${LIBVERSION_PGX_VERSION} \
	&& make \
	&& make install \
	# LIBVERSION-PGX END }}} \
	&& true \
#RUN \
	# Clean up build requirements {{{ \
	set -eux \
	\
	# Remove packages \
	&& apt-get -qq purge --auto-remove ${APT_PKGS_DEV} \
	# No `apt-get clean`: \
	# See `cat /etc/apt/apt.conf.d/docker-clean`. \
	&& rm -rf /var/lib/apt/lists/* \
	# }}} \
	&& true
