Orchestrator
param registryName string
param containerAppEnvName string
param containerAppName string
param allowedIps array = [
  '10.10.10.10'
]

module acr './acr.bicep' = {
  name: 'acr'
  params: {
    registryName: registryName
    allowedIps: allowedIps
  }
}

module log './loganalytics.bicep' = {
  name: 'log'
  params: {
    name: '${containerAppEnvName}-law'
  }
}

module acaEnv './aca-env.bicep' = {
  name: 'acaEnv'
  params: {
    envName: containerAppEnvName
    customerId: log.outputs.customerId
    sharedKey: log.outputs.sharedKey
  }
}

module app './containerapp.bicep' = {
  name: 'containerApp'
  params: {
    appName: containerAppName
    envId: acaEnv.outputs.acaEnvId
    image: '${registryName}.azurecr.io/my-nginx:v1'
    registryServer: acr.outputs.acrLoginServer
  }
}

module role './role-acrpull.bicep' = {
  name: 'role'
  params: {
    principalId: app.outputs.principalId
    acrId: acr.outputs.acrId
  }
}



If you want, I can also generate:
- A parameters JSON file
- A VNET‑integrated version (private endpoints for ACR + ACA)
- A CI/CD pipeline (Azure DevOps or GitHub Actions)
- A module for private DNS zones
Just tell me which direction you want to take this infrastructure.
