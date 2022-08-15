targetScope = 'subscription'

param aadPodIdentity bool = false
param aadPodIdentityMode string = 'managed'

param nodeResourceGroup string
param aksClusterId string
param kubeletIdentityObjectId string

param azureServiceOperator bool
@allowed([
  'Contributor'
  'Owner'
])
param azureServiceOperatorRole string

resource nrg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: nodeResourceGroup
}

module aadPodIdentityModule 'aadPodIdentity.bicep' = if (aadPodIdentity && aadPodIdentityMode == 'standard') {
  scope: nrg
  name: 'aadPodIdentityRoleAssignment'
  params: {
    aksClusterId: aksClusterId
    kubeletIdentityObjectId: kubeletIdentityObjectId
  }
}

module azureServiceOperatorIdentity 'azureServiceOperatorIdentity.bicep' = if (azureServiceOperator) {
  scope: nrg
  name: 'azureServiceOperatorIdentity'
  params: {
    location: nrg.location
  }
}

module azureServiceOperatorRoleAssignment 'azureServiceOperatorRoleAssignment.bicep' = if (azureServiceOperator) {
  name: 'azureServiceOperatorRoleAssignment'
  params: {
    asoRoleName: azureServiceOperatorRole
    identityPrincipalId: azureServiceOperatorIdentity.outputs.principalId
    identityResourceId: azureServiceOperatorIdentity.outputs.resourceId
  }
}
