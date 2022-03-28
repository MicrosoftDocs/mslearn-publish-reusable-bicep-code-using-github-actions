@description('The name of the App Service app. This name must be globally unique.')
@minLength(2)
param appServiceAppName string = 'web-${uniqueString(resourceGroup().id)}'

@description('The location for all resources.')
param location string = resourceGroup().location

@description('The SKU of the App Service plan.')
param skuName string = 'F1'

@description('The number of instances of the App Service plan.')
param skuCapacity int = 1

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'DOTNETCORE|3.0'

var appServicePlanName = 'AppServicePlan-${appServiceAppName}'

// This template spec is an example only.
// It follows some, but not all, of the guidance described at https://docs.microsoft.com/azure/app-service/security-recommendations

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity    
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output appServiceAppName string = appServiceApp.name
