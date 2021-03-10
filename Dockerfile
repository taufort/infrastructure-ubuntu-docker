FROM ubuntu:20.10

MAINTAINER Timothee Aufort

# Common tools
RUN apt update -y && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt install -y curl wget git unzip vim sudo jq

# AWS cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install

# Docker
RUN apt install -y apt-transport-https ca-certificates gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update -y  && \
    apt install -y docker-ce docker-ce-cli containerd.io

# Clean
RUN apt clean  && \
    rm -rf /tmp/aws /tmp/awscliv2.zip
