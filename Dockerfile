FROM ubuntu:xenial-20210114

LABEL mantainer="Eloy Lopez <elswork@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libfreetype6-dev \
    libpng12-dev \
    libzmq3-dev \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-scipy \
    rsync \
    software-properties-common \
    unzip \
    git \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN pip3 install -U pip==9.0.3 && \
    pip3 --no-cache-dir install \
     ipykernel \
     jupyterlab \
     matplotlib \
     numpy \
     sklearn \
     pandas \
     && \
     python3 -m ipykernel.kernelspec

ARG WHL_URL=http://ci.tensorflow.org/view/Nightly/job/nightly-pi-python3/lastSuccessfulBuild/artifact/output-artifacts/
ARG WHL_FILE=tensorflow-1.8.0-cp34-none-any.whl	

RUN curl -O ${WHL_URL}${WHL_FILE} && \
mv ${WHL_FILE} tensorflow-1.8.0-py3-none-any.whl && \
pip3 --no-cache-dir install tensorflow-1.8.0-py3-none-any.whl && \
rm -f tensorflow-1.8.0-py3-none-any.whl

COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# TensorBoard & Jupyter
EXPOSE 6006 8888

WORKDIR "/notebooks"

CMD jupyter lab --ip=* --no-browser --allow-root
