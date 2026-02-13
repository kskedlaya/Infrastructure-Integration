param registryName string
param allowedIps array
param location string = 'canadacentral'

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: registryName
  location: location
  sku: {
    name: 'Premium' // or Standard
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: 'Disabled'

    networkRuleSet: {
      defaultAction: 'Deny'
      ipRules: []
    }

    policies: {
      quarantinePolicy: {
        status: 'enabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 30
        status: 'enabled'
      }
    }

    dataEndpointEnabled: true
  }
}



output acrLoginServer string = acr.properties.loginServer
output acrId string = acr.id
