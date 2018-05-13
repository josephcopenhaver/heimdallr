FROM heimdallr:base

# DEV SPECIFICS:

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        ssh \
        git

RUN mkdir -p ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

# STANDARD BUILD:

COPY ./src/ ./

RUN make build
