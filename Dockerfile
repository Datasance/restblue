FROM node:iron-bookworm AS build-stage

# Install system dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
    bluetooth bluez bluez-hcidump libbluetooth-dev libudev-dev \
    python3 python3-dev python3-pip python3-venv 

# Upgrade pip and setuptools in a virtual environment
RUN python3 -m venv /venv && \
    /venv/bin/pip install --no-cache-dir --upgrade pip setuptools

# Set the environment variable to use the virtual environment's Python and pip
ENV PATH="/venv/bin:$PATH"


COPY src/ /src
# Install Node.js dependencies
WORKDIR /src
RUN npm install

# Final stage (minimal runtime environment)
FROM node:iron-alpine AS final-stage

# Install only necessary runtime dependencies
RUN apk add --no-cache \
    bash \
    bluez

# Copy the built files from the build stage
COPY --from=build-stage /src /src


WORKDIR /src
RUN npm prune --production

LABEL org.opencontainers.image.description=RESTBLUE
LABEL org.opencontainers.image.source=https://github.com/datasance/restblue
LABEL org.opencontainers.image.licenses=EPL2.0

# Set the default command to run your app
CMD ["node", "/src/index.js"]

