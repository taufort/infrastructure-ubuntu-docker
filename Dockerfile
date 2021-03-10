FROM ubuntu:20.10

MAINTAINER Timothee Aufort

# Common tools
RUN apt-get update -y && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y curl wget git unzip vim sudo jq

# AWS cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install

# Docker
RUN apt-get install -y apt-transport-https ca-certificates gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y  && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# AdoptOpenJDK 15
RUN curl -LfsSo /tmp/openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.2%2B7/OpenJDK15U-jdk_x64_linux_hotspot_15.0.2_7.tar.gz && \
    echo "94f20ca8ea97773571492e622563883b8869438a015d02df6028180dd9acc24d */tmp/openjdk.tar.gz" | sha256sum -c - && \
    mkdir -p /opt/java/openjdk && \
    cd /opt/java/openjdk && \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1 && \
    rm -rf /tmp/openjdk.tar.gz

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

# Clean
RUN apt-get clean && \
    rm -rf /tmp/aws /tmp/awscliv2.zip
