#!/bin/bash
set -e

echo "🧼 Skipping Node.js setup — not needed for Models project."

echo "🛠️ Fixing dotnet path..."
export PATH=$PATH:/usr/local/dotnet

echo "🔐 Injecting NuGet.Config with Codespace secret..."
mkdir -p ~/.nuget/NuGet
cat <<EOF > ~/.nuget/NuGet/NuGet.Config
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="TailspinFeed" value="https://pkgs.dev.azure.com/kweason69/_packaging/Tailspin.SpaceGame.Web.Models/nuget/v3/index.json" />
  </packageSources>
  <packageSourceCredentials>
    <TailspinFeed>
      <add key="Username" value="AzureDevOps" />
      <add key="ClearTextPassword" value="${ADO_PAT}" />
    </TailspinFeed>
  </packageSourceCredentials>
</configuration>
EOF



echo "✅ Environment setup complete."