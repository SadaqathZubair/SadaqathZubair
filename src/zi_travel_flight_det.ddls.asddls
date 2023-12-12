@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for flight details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRAVEL_FLIGHT_DET
  as select from ztravl_flght_det
  association to parent ZI_TRAVEL_ZUBMA as _TravelData on $projection.TravelUuid = _TravelData.TravelUuid
                  //                                     and $projection.TravelId = _TravelData.TravelId
{
  key mykey         as TravelUuid,
  key booking_id    as BookingId,
      travel_id     as TravelId,
      carrier_id    as CarrierId,
      @Semantics.amount.currencyCode:  'CurrencyCode'
      flight_price  as FlightPrice,
      currency_code as CurrencyCode,
      plane_type_id as PlaneTypeId,
      airport_id    as AirportId,
      name          as Name,
      city          as City,
      country       as Country,
      _TravelData
}
