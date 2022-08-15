param aksClusterId string
param kubeletIdentityObjectId string

var aadPodIdentityRoles = {
  'Managed Identity Operator': resourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
  'Virtual Machine Contributor': resourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
}

resource podIdentityRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for item in items(aadPodIdentityRoles): {
  name: guid(aksClusterId, 'RoleAssignment', item.value)
  properties: {
    principalId: kubeletIdentityObjectId
    roleDefinitionId: item.value
    principalType: 'ServicePrincipal'
  }
}]
