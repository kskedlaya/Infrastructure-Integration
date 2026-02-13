var location = 'canadacentral'
var vnetName = 'vnet-cac-int-dev-01'
var subnetName = 'subnet-cac-int-dev-01'

var vnetAddressSpace = [
  '10.0.0.0/16'
]

var subnetAddressPrefix = '10.0.1.0/24'

//
// 1. Create Route Table FIRST
//
resource rt 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'aks-rt'
  location: location
}

//
// 2. Create VNet + Subnet and ASSOCIATE the route table
//
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          /*routeTable: {
            id: rt.id   // <── NOW VALID
          }*/
        }
      }
    ]
  }
}

resource defaultRoute 'Microsoft.Network/routeTables/routes@2023-09-01' = {
  name: 'defaultRoute'
  parent: rt
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.2.4' // firewall private IP
  }
}


//
// 3. Outputs
//
output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
output locationOut string = location
