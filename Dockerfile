# Specify Node.js version (adjust as needed)
FROM node:lts-slim

# Create working directory
WORKDIR /app

# Copy package.json and index.js
COPY package.json ./

# Install dependencies
RUN npm install

# Copy remaining application files
COPY . .

# Expose port (default for HTTP)
EXPOSE 8080

# Start server (replace "index.js" with your actual main file)
CMD ["node", "index.js"]