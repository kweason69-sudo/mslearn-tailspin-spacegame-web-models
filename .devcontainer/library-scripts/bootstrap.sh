#!/bin/bash
set -e

echo "🧼 Skipping Node.js setup — not needed for Models project."

echo "🛠️ Fixing dotnet path..."
export PATH=$PATH:/usr/local/dotnet

echo "✅ Environment setup complete."