ARG VERSION=2.1.0
FROM toddbryan/geolambda:${VERSION}

LABEL maintainer="Development Seed <info@developmentseed.org>"
LABEL authors="Matthew Hanson  <matt.a.hanson@gmail.com>"

ARG PYVERSION=3.7.4

# install Python
ENV \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:/root/.pyenv/bin:$PATH

RUN \
    curl https://pyenv.run | bash; \
    CONFIGURE_OPTS="--with-openssl=${PREFIX}/openssl" \
        LD_RUN_PATH="${PREFIX}/openssl/lib" \
        pyenv install ${PYVERSION}; \
    pyenv global ${PYVERSION}; \
    pip install --upgrade pip

COPY requirements*.txt ./

RUN \
    pip install -r requirements-pre.txt; \
    pip install -r requirements.txt

# TRB Done in package script actually
# COPY bin/* /usr/local/bin/
# RUN cp -a /root/.pyenv/versions/3.7.4/bin/gdal* /usr/local/bin/
# RUN cp -a /root/.pyenv/versions/3.7.4/bin/ogr* /usr/local/bin/
