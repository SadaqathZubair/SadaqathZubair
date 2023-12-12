CLASS zcl_update_assoc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_update_assoc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: it_travels    TYPE TABLE FOR CREATE zi_travel_zubma,
          it_flights    TYPE TABLE FOR CREATE zi_travel_zubma\_Flight,
          ls_flights    LIKE LINE OF it_flights,
          it_attachment TYPE TABLE FOR CREATE zi_travel_zubma\_Attachment,
          ls_attachment LIKE LINE OF it_attachment.

    DATA: it_flghttarget  LIKE ls_flights-%target,
          it_attachtarget LIKE ls_attachment-%target.

    it_travels = VALUE #( ( %cid = 'TravelDetails'
                           AgencyId = '700892'
                           BeginDate = sy-datum
                           BookingFee = '800'
                           CurrencyCode = 'EUR'
                           CustomerId = '987'
                           Description = 'Travel Flight'
                           EndDate    = sy-datum
                           %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                               BeginDate = if_abap_behv=>mk-on
                                               BookingFee = if_abap_behv=>mk-on
                                               CurrencyCode = if_abap_behv=>mk-on
                                               CustomerId  = if_abap_behv=>mk-on
                                               Description = if_abap_behv=>mk-on
                                               EndDate     = if_abap_behv=>mk-on  ) ) ).

    it_flghttarget = VALUE #( ( %cid = 'FlightDetails'
                                 AirportId = 'BNG'
                                 BookingId = '8792726'
                                 CarrierId = 'AA'
                                 City      = 'Bangalore'
                                 Country   = 'India'
                                 CurrencyCode = 'INR'
                                 FlightPrice = '75000'
                                 Name        = 'Kempegowda International '
                                 %control = VALUE #( AirportId = if_abap_behv=>mk-on
                                                     BookingId = if_abap_behv=>mk-on
                                                     CarrierId = if_abap_behv=>mk-on
                                                     City      = if_abap_behv=>mk-on
                                                     Country   = if_abap_behv=>mk-on
                                                     CurrencyCode = if_abap_behv=>mk-on
                                                     FlightPrice  = if_abap_behv=>mk-on
                                                     Name         = if_abap_behv=>mk-on  ) ) ).



    it_attachtarget = VALUE #( (  %cid = 'Attachment'
                                   Comments = 'FlightDetailsInvoice'
                                   Filename = 'Customer Bill'
                                   %control = VALUE #( Comments = if_abap_behv=>mk-on
                                                       Filename = if_abap_behv=>mk-on ) ) ).


    it_flights = VALUE #( ( %cid_ref = 'TravelDetails'  %target = it_flghttarget ) ).

    it_attachment = VALUE #( ( %cid_ref = 'TravelDetails' %target = it_attachtarget ) ).


    MODIFY ENTITIES OF zi_travel_zubma
    ENTITY TravelDetails
    CREATE FROM it_travels
    CREATE BY \_Flight  FROM it_flights
    CREATE BY \_Attachment FROM it_attachment
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    IF lt_failed IS INITIAL.

      COMMIT ENTITIES.

out->write(
  EXPORTING
    data   = 'DATA UPDATED'
"*    name   = 'Updated'
*  RECEIVING
*    output =
).


    ENDIF.




  ENDMETHOD.

ENDCLASS.
