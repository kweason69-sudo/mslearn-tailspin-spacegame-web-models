#!/bin/bash
set -e

# Modified from https://github.com/Paul9000-MI/GitHub-Codespaces-Lab/tree/master/.devcontainer/scripts/startCodespaceADOAgent

# GitHub Codespace secrets
ADO_ORG=${ADO_ORG}
ADO_PAT=${ADO_PAT}
ADO_POOL_NAME=${ADO_POOL_NAME:-Default}

# Derived environment variables
HOSTNAME=$(hostname)
AGENT_SUFFIX="-000"
AGENT_NAME="${HOSTNAME}${AGENT_SUFFIX}"
ADO_URL="https://dev.azure.com/${ADO_ORG}"

# Agent version and download URL
AGENT_VERSION="4.263.0"
AGENT_URL="https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"
AGENT_DIR="/home/vscode/azure-pipelines"

echo "📦 Setting up Azure Pipelines agent v${AGENT_VERSION} [${AGENT_NAME}]..."
if [ -d "$AGENT_DIR" ]; then
  echo "🧹 Cleaning up old agent directory..."
  rm -rf "$AGENT_DIR"
fi

mkdir -p "$AGENT_DIR"
cd "$AGENT_DIR"

# Download and extract agent
echo "⬇️ Downloading agent from: $AGENT_URL"
if ! curl --connect-timeout 10 --max-time 30 -Ls "$AGENT_URL" | tar -xz; then
  echo "❌ Failed to download or extract agent. Check URL or network access."
  exit 1
fi

# Ignore sensitive env vars
export VSO_AGENT_IGNORE="ADO_PAT,GH_TOKEN,GITHUB_CODESPACE_TOKEN,GITHUB_TOKEN"

# Configure agent
echo "⚙️ Configuring agent [${AGENT_NAME}]..."
./config.sh --unattended \
  --agent "${AGENT_NAME}" \
  --url "${ADO_URL}" \
  --auth PAT \
  --token "${ADO_PAT}" \
  --pool "${ADO_POOL_NAME}" \
  --replace \
  --acceptTeeEula

# Start agent
echo "🚀 Starting agent..."
./run.sh &
