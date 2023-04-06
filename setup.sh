#!/bin/bash

# Setup React SPA with Vite

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
  echo "Node.js and npm are required. Please install them before running this script."
  exit 1
fi

# Check if Vite is installed
if ! command -v vite &> /dev/null; then
  echo "Vite is not installed. Installing Vite..."
  npm install -g vite
fi

# Create React project in frontend
echo "Creating a React app..."
npm create vite@latest frontend -- --template react

# Install dependencies and build app
echo "Installing dependencies and building the React app..."
cd frontend
npm install
npm run build

echo "React SPA setup complete."