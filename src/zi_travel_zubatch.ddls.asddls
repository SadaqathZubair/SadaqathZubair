@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for attachment table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRAVEL_ZUBATCH
  as select from ztravel_zub_atch as Attachment
  association to parent ZI_TRAVEL_ZUBMA as _TravelData on $projection.TravelUuid = _TravelData.TravelUuid
{
  key travel_uuid as TravelUuid,
      comments    as Comments,
      @EndUserText.label: 'Upload Attachment'
      @Semantics.largeObject: {
          mimeType: 'Mimetype',
          fileName: 'Filename',
          contentDispositionPreference: #ATTACHMENT ,
          acceptableMimeTypes: [ 'application/pdf' ] }
          
      attachment  as Attachment,
      mimetype    as Mimetype,
      filename    as Filename,
      _TravelData
}
