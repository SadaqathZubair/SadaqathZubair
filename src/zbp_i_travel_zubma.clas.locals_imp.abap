CLASS lhc_flightdetails DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CalculateTravelKey FOR DETERMINE ON MODIFY
      IMPORTING keys FOR FlightDetails~CalculateTravelKey.

ENDCLASS.

CLASS lhc_flightdetails IMPLEMENTATION.

  METHOD CalculateTravelKey.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
        ENTITY FlightDetails
          FIELDS ( TravelId )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).

    DELETE lt_travel WHERE TravelId IS NOT INITIAL.
    CHECK lt_travel IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zi_travel_zubma FIELDS MAX( TravelId ) INTO @DATA(lv_max_travelid).

    "update involved instances
    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
      ENTITY FlightDetails
        UPDATE FIELDS ( TravelId )
        WITH VALUE #( FOR ls_travel IN lt_travel INDEX INTO i (
                           %key      = ls_travel-%key
                           TravelId  = lv_max_travelid + i ) )
    REPORTED DATA(lt_reported).



  ENDMETHOD.

ENDCLASS.

CLASS lhc_TravelDetails DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR TravelDetails RESULT result.
    METHODS setstatus FOR MODIFY
      IMPORTING keys FOR ACTION traveldetails~setstatus RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR traveldetails RESULT result.
    METHODS validateagencyid FOR VALIDATE ON SAVE
      IMPORTING keys FOR traveldetails~validateagencyid.
    METHODS determinebookingstatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR traveldetails~determinebookingstatus.
    METHODS determinebookingstatusmod FOR DETERMINE ON MODIFY
      IMPORTING keys FOR traveldetails~determinebookingstatusmod.
    METHODS CalculateTravelKey         FOR DETERMINE ON MODIFY IMPORTING keys FOR traveldetails~CalculateTravelKey.
    METHODS CreateRecords FOR MODIFY
      IMPORTING keys FOR ACTION TravelDetails~CreateRecords RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR TravelDetails RESULT result.
    METHODS CopyRecords FOR MODIFY
      IMPORTING keys FOR ACTION TravelDetails~CopyRecords.
    METHODS CreateDefalutValuesRecord FOR MODIFY
      IMPORTING keys FOR ACTION TravelDetails~CreateDefalutValuesRecord.


    METHODS: update_auth RETURNING VALUE(allowed_update) TYPE abap_boolean.


ENDCLASS.

CLASS lhc_TravelDetails IMPLEMENTATION.

  METHOD get_instance_authorizations.

    DATA: Update_request TYPE abap_bool.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(it_ostatus).

    CHECK it_ostatus IS NOT INITIAL.

    update_request = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
                                  requested_authorizations-%action-Edit = if_abap_behv=>mk-on
                                  THEN abap_true
                                  ELSE abap_false ).

    LOOP AT it_ostatus ASSIGNING FIELD-SYMBOL(<ls_ostatus>).

      IF <ls_ostatus>-OverallStatus = 'N' AND update_request = abap_true AND
      update_auth( ) = abap_false.

        APPEND VALUE #( %tky = <ls_ostatus>-%tky ) TO failed-traveldetails.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = 'NO AUTHORIZATION TO CHANGE STATUS FOR UPDATEDSTATUS' ) )
                               TO reported-traveldetails.


      ENDIF.

    ENDLOOP.






  ENDMETHOD..



  METHOD SetStatus.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails FIELDS ( TotalPrice OverallStatus )
    WITH CORRESPONDING #( keys ) RESULT DATA(it_travel).

    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR gs_travel IN it_travel
                ( %tky = keys[ 1 ]-%tky
                  overallstatus = COND #(  WHEN gs_travel-TotalPrice GE '5000'
                                           THEN  'G'
                                           ELSE gs_travel-OverallStatus ) ) )

    FAILED failed
    REPORTED reported.

    result = VALUE #( FOR is_status IN it_travel
                         ( %tky = is_status-%tky
                           %param = is_status ) ).


  ENDMETHOD.

  METHOD get_instance_features.

    DATA: lt_travldata TYPE TABLE OF zi_travel_zubma.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_setenble)
    FAILED failed.

    CHECK it_setenble IS NOT INITIAL.

    result = VALUE #( FOR ls_setenble IN it_setenble
                      LET ls_enble = COND #( WHEN ls_setenble-OverallStatus = 'O'
                                             THEN fco-disabled
                                             ELSE fco-enabled )
                                             IN ( %tky =  ls_setenble-%tky
                                                  %action-SetStatus = ls_enble ) ).


  ENDMETHOD.

  METHOD ValidateAgencyID.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails FIELDS ( AgencyId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(ItAgencyID).

    LOOP AT ItAgencyID INTO DATA(isagencyid).

      IF isagencyid-AgencyId IS INITIAL.

        APPEND VALUE #( %tky = isagencyid-%tky ) TO failed-traveldetails.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = 'Agency ID Cannot Be Initial' ) ) TO reported-traveldetails.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD DetermineBookingStatus.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails FIELDS ( BookingFee  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(it_bookingfee).

    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_booking IN it_bookingfee
                ( %tky = ls_booking-%tky
                  OverallStatus = COND #( WHEN ls_booking-BookingFee > '800'
                                          THEN 'A'
                                          ELSE  'O' )  ) ).




  ENDMETHOD.

  METHOD DetermineBookingStatusMod.


    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails FIELDS ( BookingFee  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(It_BookingMod).

    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_bookingmod IN It_BookingMod
                 (  %tky = ls_bookingmod-%tky
                    OverallStatus = COND #( WHEN ls_bookingmod-BookingFee < '800'
                                            THEN 'M'
                                            ELSE 'N' ) ) ).


  ENDMETHOD.

  METHOD calculatetravelkey.
    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
        ENTITY TravelDetails
          FIELDS ( TravelId )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).

    DELETE lt_travel WHERE TravelId IS NOT INITIAL.
    CHECK lt_travel IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zi_travel_zubma FIELDS MAX( TravelId ) INTO @DATA(lv_max_travelid).

    "update involved instances
    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
      ENTITY TravelDetails
        UPDATE FIELDS ( TravelId )
        WITH VALUE #( FOR ls_travel IN lt_travel INDEX INTO i (
                           %key      = ls_travel-%key
                           TravelId  = lv_max_travelid + i ) )
    REPORTED DATA(lt_reported).



  ENDMETHOD.


  METHOD CreateRecords.

    DELETE FROM ztravel_zub_db.
    INSERT ztravel_zub_db FROM (
        SELECT FROM zrap_atrav_dor
        FIELDS
      travel_uuid     AS mykey,
      travel_id       AS TravelId,
      agency_id       AS AgencyId,
      customer_id     AS CustomerId,
      begin_date      AS BeginDate,
      end_date        AS EndDate,
      booking_fee     AS BookingFee,
      total_price     AS TotalPrice,
      currency_code   AS CurrencyCode,
      description     AS Description,
      overall_status  AS OverallStatus,
      last_changed_at    AS LastChangDat,
      local_last_changed_at AS LocalLastChange
      ORDER BY travel_id UP TO 100 ROWS ).



  ENDMETHOD.

  METHOD get_global_authorizations.

    IF requested_authorizations-%update = if_abap_behv=>mk-on OR
       requested_authorizations-%action-edit  = if_abap_behv=>mk-on.

      IF update_auth( ) = abap_true.

        result-%update = if_abap_behv=>auth-allowed.
        result-%action-Edit = if_abap_behv=>auth-allowed.

      ELSE.

        result-%update = if_abap_behv=>auth-unauthorized.
        result-%action-Edit = if_abap_behv=>auth-unauthorized.
        result-%delete = if_abap_behv=>auth-unauthorized.

      ENDIF.

    ENDIF.



  ENDMETHOD.

  METHOD update_auth.

    allowed_update = abap_true.

  ENDMETHOD.

  METHOD CopyRecords.

    DATA: ls_copyrecs TYPE zi_travel_zubma.
    DATA: lt_copyrecords TYPE TABLE FOR CREATE zi_travel_zubma.

    READ ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(it_copyrec)
    FAILED failed.

    LOOP AT it_copyrec ASSIGNING FIELD-SYMBOL(<ls_copyrec>).


      APPEND VALUE #( %cid = keys[ KEY entity %key = <ls_copyrec>-%key ]-%cid
                      %data = CORRESPONDING #( <ls_copyrec> EXCEPT Traveluuid ) )
                      TO lt_copyrecords ASSIGNING FIELD-SYMBOL(<gs_copyrecos>).



    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails
    CREATE
    FIELDS ( AgencyId BeginDate BookingFee CurrencyCode
             CustomerId Description EndDate TotalPrice
             TravelId )
    WITH lt_copyrecords
    MAPPED DATA(gt_copyrecords).

    mapped-traveldetails = gt_copyrecords-traveldetails.



  ENDMETHOD.


  METHOD CreateDefalutValuesRecord.

    DATA: lt_values TYPE TABLE FOR CREATE ZI_TRAVEL_ZUBMA.

    MODIFY ENTITIES OF zi_travel_zubma IN LOCAL MODE
    ENTITY TravelDetails
    CREATE FROM VALUE #( FOR <ls_values> IN keys
                       ( %cid = <ls_values>-%cid
                         AgencyId = '99999'
                         BookingFee = '600'
                         CurrencyCode = 'EUR'
  %control = VALUE  #( AgencyId = if_abap_behv=>mk-on
                       BookingFee = if_abap_behv=>mk-on
                       CurrencyCode = if_abap_behv=>mk-off   ) ) )
 MAPPED mapped
 FAILED failed
 REPORTED reported.



  ENDMETHOD.



ENDCLASS.
