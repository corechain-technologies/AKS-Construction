targetScope = 'subscription'

param identityResourceId string
param identityPrincipalId string

@allowed([
  'Contributor'
  'Owner'
])
param asoRoleName string

var aadPodIdentityRoles = {
  Contributor: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
}

resource podIdentityRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(identityResourceId, subscription().id, 'RoleAssignment', asoRoleName)
  properties: {
    principalId: identityPrincipalId
    roleDefinitionId: aadPodIdentityRoles[asoRoleName]
    principalType: 'ServicePrincipal'
  }
}

