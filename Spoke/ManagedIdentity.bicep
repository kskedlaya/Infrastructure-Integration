param identityName string
param location string = 'canadacentral'

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

output identityId string = uami.id
output principalId string = uami.properties.principalId
