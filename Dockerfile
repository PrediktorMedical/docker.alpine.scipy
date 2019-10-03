FROM alpine:3.10

RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN echo "http://nl.alpinelinux.org/alpine/v3.10/main" > /etc/apk/repositories

COPY libs/* /tmp/

RUN apk update &&\
    apk add python3 \
            python3-dev \
            ca-certificates \
            openntpd \
            build-base \
            musl-dev \
            gfortran \
            libgfortran

RUN python3 /tmp/get-pip.py

# Build BLAS and LAPACK
#RUN source /tmp/blas.sh
#RUN source /tmp/lapack.sh

#RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

# Install numpy, pandas, scipy and scikit
#RUN BLAS=~/src/BLAS/libfblas.a LAPACK=~/src/lapack-3.5.0/liblapack.a pip install -v numpy==1.11.0
#RUN BLAS=~/src/BLAS/libfblas.a LAPACK=~/src/lapack-3.5.0/liblapack.a pip install -v pandas==0.18.0
#RUN BLAS=~/src/BLAS/libfblas.a LAPACK=~/src/lapack-3.5.0/liblapack.a pip install -v scipy==0.18.0
#RUN BLAS=~/src/BLAS/libfblas.a LAPACK=~/src/lapack-3.5.0/liblapack.a pip install -v scikit-learn==0.17.1

# Clean up
#RUN mv ~/src/BLAS/libfblas.a /tmp/
#RUN mv ~/src/lapack-3.5.0/liblapack.a /tmp/
#RUN rm -rf ~/src
#RUN rm -rf ~/.cache/pip
#RUN mkdir -p ~/src/BLAS ~/src/lapack-3.5.0
#RUN mv /tmp/libfblas.a ~/src/BLAS/libfblas.a
#RUN mv /tmp/liblapack.a ~/src/lapack-3.5.0/liblapack.a
#RUN rm -rf /tmp/*

# Remove all the extra build stuff
#RUN apk del build-base "*-dev"


# make a rest-service-machine-learning user
RUN adduser -D rsml
WORKDIR /home/rsml

RUN apk --no-cache --update-cache add python3-dev musl-dev

# make a virtual environment, install key komponents
# The gunicorn and gevent components are for high performance servers. Adjust in boot.sh
#RUN PYTHONPATH=/usr/bin/python pip install --upgrade pip 
RUN PYTHONPATH=/usr/bin/python pip install bottle
RUN PYTHONPATH=/usr/bin/python pip install requests

# RUN venv/bin/pip install numpy
RUN PYTHONPATH=/usr/bin/python pip install gunicorn

RUN PYTHONPATH=/usr/bin/python pip install gevent
