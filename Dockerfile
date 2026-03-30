# Build stage
FROM node:22-slim AS builder
WORKDIR /usr/src/app

# Copy dependency manifests
COPY package*.json ./

# Install ALL dependencies (including devDependencies like typescript)
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Production stage
FROM node:22-slim
WORKDIR /usr/src/app

# Copy dependency manifests
COPY package*.json ./

# Install ONLY production dependencies
RUN npm install --production

# Copy built assets from builder stage
COPY --from=builder /usr/src/app/build ./build

EXPOSE 8100

# Run the web service
CMD ["npm", "start"]
