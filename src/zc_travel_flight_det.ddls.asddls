@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for flight details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_TRAVEL_FLIGHT_DET
  as projection on ZI_TRAVEL_FLIGHT_DET
{
  key TravelUuid,
  key BookingId,
      TravelId,
      CarrierId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      PlaneTypeId,
      AirportId,
      Name,
      City,
      Country,
      /* Associations */
      _TravelData : redirected to parent ZC_TRAVEL_ZUB
}
