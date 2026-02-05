param registryName string
param location string = resourceGroup().location
param allowedIps array

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: registryName
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: 'Disabled'
    networkRuleSet: {
      defaultAction: 'Deny'
      ipRules: [
        for ip in allowedIps: {
          action: 'Allow'
          value: ip
        }
      ]
    }
  }
}

output acrId string = acr.id
output acrLoginServer string = acr.properties.loginServer