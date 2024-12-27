
#!/bin/bash

# Deploy a twotier flask app and handle errors

# Function to clone the Flask app code

repository_clone() {
    echo "Cloning the twotier flask app..."
    if [ -d "Multi-Region_VPC" ]; then
        echo "The repository already exists. Skipping clone."
    else
        git clone https://github.com/Umair1012/Multi-Region_VPC.git || {
            echo "Failed to clone the repository."
            return 1
        }
    fi
}

# Function to install required dependencies

install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get update && sudo apt-get install -y docker.io nginx docker-compose || {
        echo "Failed to install dependencies."
        return 1
    }
}

# Function to give permission to current user to run docker-compose command without sudo command

required_permission() {
    echo "Performing changing ownership..."
    sudo chown "$USER" /var/run/docker.sock || {
        echo "Failed to change ownership of docker.sock."
        return 1
    }
}

# Function to deploy the twotier flask app
deploy_app() {
    echo "Building and deploying the flask app..."
    docker-compose up -d || {
        echo "Failed to build and deploy the app."
        return 1
    }
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

# Clone the code
if ! repository_clone; then
    cd Multi-Region_VPC || exit 1
fi

# Install dependencies
if ! install_requirements; then
        echo "Installation failed.."
    exit 1
fi

# Perform required permission
if ! required_permission; then
    exit 1
fi

# Deploy the app
if ! deploy_app; then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
