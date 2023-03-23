#!/bin/bash

# A simple setup script to create a Vue.js app.

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
  echo "Node.js and npm are required. Please install them before running this script."
  exit 1
fi

# Check if Vue CLI is installed, and install it if it's not
if ! command -v vue &> /dev/null; then
  echo "Installing Vue CLI..."
  npm install -g @vue/cli
fi

# Create a Vue 3 app inside the frontend directory
echo "Creating a Vue 3 app..."
vue create frontend

# Configure Vue to output to the /dist directory
echo "Updating Vue build output path to /dist directory..."
cd frontend
mkdir dist
cat > vue.config.js << EOL
module.exports = {
  outputDir: "dist"
}
EOL

# Install dependencies and build the Vue app
echo "Installing dependencies and building the Vue app..."
npm install
npm run build

echo "Vue 3 app setup complete."