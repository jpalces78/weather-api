# Use the official Node.js image as the base image
FROM node:14

# Create and set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the application files to the working directory
COPY . .

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["node", "index.js"]  # Adjust this line based on your entry point file
