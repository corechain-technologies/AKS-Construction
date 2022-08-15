param location string = resourceGroup().location

resource asoIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'azureServiceOperatorIdentity'
  location: location
}

output clientId string = asoIdentity.properties.clientId
output principalId string = asoIdentity.properties.principalId
output resourceId string = asoIdentity.id
