FROM alpine:3

ARG ANSIBLE_VERSION=10.2.0

ENV ANSIBLE_VERSION=$ANSIBLE_VERSION

RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python3-dev && \
    \
    echo "==> Adding Python runtime..."  && \
    apk add --no-cache  bash \
        curl \
        tar \
        openssh-client \
        sshpass \
        rsync \
        git \
        python3 \
        py3-boto3 \
        py3-dateutil \
        py3-httplib2 \
        py3-jinja2 \
        py3-paramiko \
        py3-pip \
        py3-yaml \
        ca-certificates \
    && \
    pip install --upgrade pip && \
    pip install python-keyczar docker-py && \
    \
    echo "==> Installing Ansible..."  && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf '/var/cache/apk/*'

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library

WORKDIR /ansible/playbooks

ENTRYPOINT ["ansible-playbook"]
