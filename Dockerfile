FROM python:3.9.21-alpine3.21 AS build-stage

# Install necessary Alpine packages
RUN apk add --no-cache \
    curl \
    bash \
    bluez \
    bluez-deprecated \
    build-base \
    python3-dev \
    py3-pip \
    linux-headers \
    nodejs \
    npm

# Upgrade pip and ensure distutils is available
RUN pip install --no-cache-dir --upgrade pip setuptools

COPY . /src
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

# Set the default command to run your app
CMD ["node", "/src/index.js"]