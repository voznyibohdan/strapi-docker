FROM node:18-alpine3.18

# Installing dependencies
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

# Set environment variables
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies with increased timeout and network retry settings
RUN npm config set fetch-retry-maxtimeout 600000 -g && \
    npm config set fetch-retry-mintimeout 20000 -g && \
    npm config set fetch-retries 4 -g && \
    npm install

# Copy application files
COPY . .

# Build the Strapi application
RUN npm run build

# Expose the port Strapi will run on
EXPOSE 1337

# Start command
CMD ["npm", "run", "develop"]