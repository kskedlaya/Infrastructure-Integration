param aksName string ='aks-cac-int-dev-01'
param location string = resourceGroup().location

// 1. Log Analytics Workspace
module logAnalytics './logAnalyticsworkspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    name: 'kedlaya-law'
    location: 'canadacentral'
  }
}

// 2. VNET + Subnet
module vnetModule './vnetandsubnet.bicep' = {
  name: 'vnetDeployment'
  params: {}
}

// 3. AKS Cluster
module aksCluster './aksCluster.bicep' = {
  name: 'aksCluster'
  params: {
    aksName: aksName
    subnetId: vnetModule.outputs.subnetId
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }
}
