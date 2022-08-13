targetScope = 'subscription'

param nodeResourceGroup string
param aksClusterId string
param kubeletIdentityObjectId string

resource nrg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: nodeResourceGroup
}

module aadPodIdentity 'aadPodIdentity.bicep' = {
  scope: nrg
  name: 'aadPodIdentityRoleAssignment'
  params: {
    aksClusterId: aksClusterId
    kubeletIdentityObjectId: kubeletIdentityObjectId
  }
}
