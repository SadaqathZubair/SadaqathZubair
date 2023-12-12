@EndUserText.label: 'Projection view for attachment table'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZP_TRAVEL_ZUBATCH
  as projection on ZI_TRAVEL_ZUBATCH
{


      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key TravelUuid,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      Comments,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      Attachment,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      Mimetype,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      Filename,
      /* Associations */
      _TravelData: redirected to parent ZC_TRAVEL_ZUB
     
}
