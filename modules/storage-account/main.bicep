@description('The name of the App Service app. This name must be globally unique.')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'stor${uniqueString(resourceGroup().id)}'

@description('The location for all resources.')
param location string = resourceGroup().location

@description('The name of the SKU to use for the Azure Storage account.')
param storageAccountSkuName string = 'Standard_LRS'

var softDeleteRetentionPeriodDays = 7

// This module is an example only.
// It follows some, but not all, of the guidance described at https://docs.microsoft.com/azure/storage/blobs/security-recommendations

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSkuName
  }
  properties: {
    supportsHttpsTrafficOnly: true
    allowSharedKeyAccess: false
  }

  resource blobService 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: true
        days: softDeleteRetentionPeriodDays
      }
      containerDeleteRetentionPolicy: {
        enabled: true
        days: softDeleteRetentionPeriodDays
      }
    }
  }
}

output storageAccountName string = storageAccount.name
