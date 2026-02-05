param name string
param location string = resourceGroup().location

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  properties: {
    retentionInDays: 30
  }
}

output lawId string = law.id
output customerId string = law.properties.customerId
output sharedKey string = law.listKeys().primarySharedKey