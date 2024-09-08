# Use the official Python image as a base
FROM mcr.microsoft.com/vscode/devcontainers/python:3

# Install any needed dependencies for OCI CLI
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    python3-pip

# Install OCI CLI
RUN pip3 install oci-cli

# Verify installation
RUN oci --version
