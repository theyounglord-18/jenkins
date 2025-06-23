FROM jenkins/jenkins:2.424.3-jdk11

USER root

RUN apt-get update && apt-get install -y \
    lsb-release \
    python3 \
    python3-pip \
    git

# Ensure 'python3' and 'python' are both available in path
RUN ln -s /usr/bin/python3 /usr/bin/python || true
RUN ln -s /usr/bin/pip3 /usr/bin/pip || true

# Set environment variables to ensure python is in PATH
ENV PATH="/usr/bin:$PATH"

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"
