#!/bin/bash
set -e

# -------- SETTINGS (Update accordingly) --------
RUNNER_VERSION="2.323.0"
REPO_URL="https://github.com/DMSS-Jan2025-Team9"
REGISTRATION_TOKEN="AEZQDYMIB75FAID3PHRLN2DICYWOI"  # Replace with a valid registration token
RUNNER_NAME=$(hostname)
RUNNER_GROUP="cmrs-runner-group"
RUNNER_LABELS="$RUNNER_NAME"
# ----------------------------------------------

echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y jq curl apt-transport-https ca-certificates software-properties-common

echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USER

echo "Docker version:"
docker --version

echo "Setting up GitHub Actions Runner..."
mkdir -p actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

echo "Configuring the runner..."
./config.sh \
  --url "$REPO_URL" \
  --token "$REGISTRATION_TOKEN" \
  --name "$RUNNER_NAME" \
  --runnergroup "$RUNNER_GROUP" \
  --labels "$RUNNER_LABELS" \
  --unattended

echo "Installing service..."
sudo ./svc.sh install

echo "Starting service..."
sudo ./svc.sh start
