param aksName string
param subnetId string
param location string
param logAnalyticsWorkspaceId string

resource aks 'Microsoft.ContainerService/managedClusters@2023-07-01' = {
  name: aksName
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    disableLocalAccounts: true
    dnsPrefix: '${aksName}-dns'

    autoUpgradeProfile: {
      upgradeChannel: 'stable'
    }

    apiServerAccessProfile: {
      authorizedIPRanges: [
        '0.0.0.0/0'
      ]
    }

    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'true'
          rotationPollInterval: '2m'
        }
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
      kubeDashboard: {
        enabled: false
      }
      azurepolicy: {
        enabled: true
      }
    }

    enableRBAC: true

      networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidrs: [
        '10.2.0.0/24'
      ]
      dnsServiceIP: '10.2.0.10'
      loadBalancerSku: 'standard'
      outboundType: 'userDefinedRouting'
    }

    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 1
        vmSize: 'Standard_E8s_v3'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        vnetSubnetID: subnetId
        osDiskType: 'Ephemeral'
        maxPods: 50

        // Required for encryptionAtHost to work
      }
    ]
  }
}
