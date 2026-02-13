param principalId string
param acrId string

resource acrResource 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: last(split(acrId, '/'))
}

resource acrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acrId, principalId, 'acrpull')
  scope: acrResource
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d'
    )
    principalId: principalId
  }
}
