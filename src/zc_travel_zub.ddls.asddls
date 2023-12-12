@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for travel details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZC_TRAVEL_ZUB
  as projection on ZI_TRAVEL_ZUBMA
{

          @UI.facet: [ { id:              'Travel',
                         purpose:         #STANDARD,
                         type:            #IDENTIFICATION_REFERENCE,
                         label:           'TravelDetails',
                         position:        10 } ]

          @UI.lineItem: [{ position: 05 }]
          @UI.identification: [ { position: 05 } ]
          @UI.hidden: true
  key     TravelUuid,
          @UI.lineItem: [{ position: 10 }]
          @UI.identification: [ { position: 10, label: 'Travel ID [1,...,99999999]' } ]
          TravelId,
          @UI.lineItem: [{ position: 20 }]
          @UI.identification: [{ position: 20 }]
          AgencyId,
          @UI.lineItem: [{ position: 30 }]
          @UI.identification: [{ position: 30 }]
          CustomerId,
          @UI.lineItem: [{ position: 40 }]
          @UI.identification: [{ position: 40 }]
          BeginDate,
          @UI.lineItem: [{ position: 50 }]
          @UI.identification: [{ position: 50 }]
          EndDate,
          @UI.lineItem: [{ position: 60 }]
          @UI.identification: [{ position: 60 }]
          @Semantics.amount.currencyCode: 'CurrencyCode'
          BookingFee,
          @UI.lineItem: [{ position: 70 }]
          @UI.identification: [{ position: 70 }]
          @Semantics.amount.currencyCode: 'CurrencyCode'
          TotalPrice,
          @UI.lineItem: [{ position: 80 }]
          @UI.identification: [{ position: 80 }]
          CurrencyCode,
          @UI.lineItem: [{ position: 90 }]
          @UI.identification: [{ position: 90 }]
          Description,
          @UI.lineItem: [{ position: 100 } ]
          @UI.identification: [{ position: 100 }]
          OverallStatus,
          @UI.lineItem: [{ position: 110 }]
          @UI.identification: [{ position: 110 }]
          LastChangDat,
          @UI.lineItem: [{ position: 120 }]
          @UI.identification: [{ position: 120 }]
          LocalLastChange,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BOOKINGDISCOUNT'
          @EndUserText.label: 'BookingDiscount'
          virtual BonusDiscount : abap.int4,
          _Flight : redirected to composition child ZC_TRAVEL_FLIGHT_DET,
          _Attachment: redirected to composition child ZP_TRAVEL_ZUBATCH 

}
