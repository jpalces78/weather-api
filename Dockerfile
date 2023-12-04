FROM node:lts-slim

WORKDIR /usr/src/app

# Copy the package.json file
COPY package.json package.json

# Install dependencies
RUN npm install

# Copy the entire application directory
COPY . .

# Expose port 8080 (default Cloud Run port)
EXPOSE 8080

# Set the main entry point
CMD ["node", "index.js"]

# (Optional) Add a health check endpoint
# This helps Cloud Run determine if the container is healthy
RUN echo "HTTP/1.1 200 OK" > /healthz && \
    echo "Content-Type: text/plain" >> /healthz && \
    echo "Healthy" >> /healthz

# (Optional) Add a custom entrypoint script
# This can be useful for running pre-start scripts or environment setup
RUN echo "#!/bin/sh" > /entrypoint.sh && \
    echo "node ./wait-for-it.js db:3306 --timeout=60 && node index.js" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# (Optional) Use a multi-stage build for smaller image size
# This separates development dependencies from the final image

# STAGE 1: Build dependencies
FROM node:lts-slim

WORKDIR /usr/src/app

COPY package.json package.json

RUN npm install --production

# Copy only necessary files (excluding node_modules)
COPY --from=0 /usr/src/app/package.json .

# STAGE 2: Build the final image
FROM node:lts-slim

WORKDIR /usr/src/app

COPY package.json package-lock.json .

RUN npm install --production

# Add remaining application files
COPY --from=0 . .

EXPOSE 8080

CMD ["node", "index.js"]

# ...
