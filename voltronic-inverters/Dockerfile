ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install dependencies
RUN apt-get update && apt-get install -y \
        git \
        build-essential \
        cmake \
        jq \
        mosquitto-clients \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /opt

# Define the desired commit hash
ARG GIT_COMMIT=a01e305846c697d985847405909e91ba81289a49

# Clone the repository with Sparse Checkout and check out the specific commit
RUN git clone --filter=blob:none --no-checkout https://github.com/catalinbordan/docker-voltronic-homeassistant.git repo && \
    cd repo && \
    git fetch origin $GIT_COMMIT && \
    git checkout $GIT_COMMIT && \
    git sparse-checkout init --cone && \
    git sparse-checkout set sources config

# Create the destination directory and copy necessary files
RUN mkdir -p /etc/inverter && \
    cp -r repo/sources/* /opt/ && \
    cp -r repo/config/* /etc/inverter/

# Remove the cloned repository to reduce image size
RUN rm -rf repo

# Copy the run.sh script from the build context to the container
COPY run.sh /run.sh
RUN chmod a+x /run.sh

RUN sed -i '1i#include <string>' /opt/inverter-cli/inverter.h

# Build the inverter CLI
RUN cd /opt/inverter-cli && \
    mkdir bin && \
    cmake . && \
    make && \
    mv inverter_poller bin/

# Configure healthcheck
HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=1m \
    --retries=3 \
  CMD /opt/healthcheck

# Set the startup command
CMD [ "/run.sh" ]
