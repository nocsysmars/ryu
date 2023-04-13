FROM python:3.8-alpine

MAINTAINER Will Fantom <macauley_cheng@accton.com>

RUN apk add --virtual .build-dependencies \
    gcc \
    git \
    libffi-dev \
    libgcc \
    libxslt-dev \
    libxml2-dev \
    make \
    musl-dev \
    openssl-dev \
    zlib-dev

ENV RYU_BRANCH master
ENV RYU_TAG v4.34
ENV HOME /root
WORKDIR /root
#RUN git clone -b ${RYU_BRANCH} https://github.com/osrg/ryu.git && \
#    cd ryu && \
#    git checkout tags/${RYU_TAG} && \
#
RUN git clone -b ${RYU_BRANCH}  https://github.com/nocsysmars/ryu.git && \
    cd ryu && \
    pip install . && \
    pip install -r tools/optional-requires

RUN apk del .build-dependencies

RUN echo "#!/bin/ash" > /root/run.sh
RUN echo "cd /usr/local/bin ;ryu-manager --enable-debugger ../lib/python3.8/site-packages/ryu/app/rest_vtep.py" >> /root/run.sh
RUN chmod a+x /root/run.sh

#ENTRYPOINT ["/bin/ash"]
ENTRYPOINT ["/root/run.sh"]
