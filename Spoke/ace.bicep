param envName string
param location string = 'canadacentral'
param customerId string

resource acaEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: envName
  location: location
  properties: {
    
  }
}


output acaEnvId string = acaEnv.id
