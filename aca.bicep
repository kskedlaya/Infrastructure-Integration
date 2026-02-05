param appName string
param envId string
param image string
param registryServer string

resource app 'Microsoft.Web/containerApps@2023-05-01' = {
  name: appName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    environmentId: envId
    configuration: {
      ingress: {
        external: false
        targetPort: 80
      }
      registries: [
        {
          server: registryServer
          identity: 'system'
        }
      ]
    }
    template: {
      containers: [
        {
          name: appName
          image: image
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

output principalId string = app.identity.principalId
output appId string = app.id