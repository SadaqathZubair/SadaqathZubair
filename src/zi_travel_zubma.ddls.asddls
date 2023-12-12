@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for travel details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TRAVEL_ZUBMA
  as select from ztravel_zub_db
  association [0..1] to I_Currency           as _Currency on $projection.CurrencyCode = _Currency.Currency
  composition [1..*] of ZI_TRAVEL_FLIGHT_DET as _Flight
  composition [1..*] of ZI_TRAVEL_ZUBATCH    as _Attachment
{

      //      @UI: { identification: [{ position: 10 }],
      //           lineItem: [{ position: 10 }] }
  key mykey           as TravelUuid,
      travel_id       as TravelId,
      //  @UI: { identification: [{ position: 20 }],
      //       lineItem: [{ position: 20 }] }
      agency_id       as AgencyId,
      //@UI: { identification: [{ position: 30 }],
      //     lineItem: [{ position: 30 }]}
      customer_id     as CustomerId,
      //@UI: {identification: [{ position: 40 }],
      //    lineItem: [{ position: 40 }] }
      begin_date      as BeginDate,
      //@UI: {identification: [{ position: 50 }],
      //    lineItem: [{ position: 50 }] }
      end_date        as EndDate,
      //@UI: {identification: [{ position: 60 }],
      //    lineItem: [{ position: 60 }] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      //      @UI: { identification: [{ position: 70 }],
      //           lineItem: [{ position: 70 }]}
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      //  @UI: {identification: [{ position: 80 }],
      //      lineItem: [{ position: 80 }] }
      currency_code   as CurrencyCode,
      //@UI: { identification: [{ position: 90 }],
      //     lineItem: [{ position: 90 }]}
      description     as Description,
      //@UI: { identification: [{ position: 100 }],
      //     lineItem: [{ position: 100 }]}
      overall_status  as OverallStatus,
      lastchangdat    as LastChangDat,
      locallastchange as LocalLastChange,
      _Currency,
      _Flight,
      _Attachment

}
