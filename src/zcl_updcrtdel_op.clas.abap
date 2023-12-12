CLASS zcl_updcrtdel_op DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_updcrtdel_op IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


    DATA: it_students       TYPE TABLE FOR CREATE zi_travel_zubma,
          it_studentsupdate TYPE TABLE FOR UPDATE zi_travel_zubma,
          it_flights        TYPE TABLE FOR DELETE zi_travel_zubma.

    DATA: op_table    TYPE abp_behv_changes_tab,
          lt_failed   TYPE abp_behv_response_tab,
          lt_reported TYPE abp_behv_response_tab,
          lt_mapped   TYPE abp_behv_response_tab.

    it_students = VALUE #( ( %cid = 'TravelDetails'
                             AgencyId = '589765'
                             BeginDate = sy-datum
                             BookingFee = '8750'
                             CurrencyCode = 'ÉUR'
                             CustomerId   = '555'
                             OverallStatus = 'B'
                             %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                                 BeginDate = if_abap_behv=>mk-on
                                                 BookingFee = if_abap_behv=>mk-on
                                                 CurrencyCode = if_abap_behv=>mk-on
                                                 CustomerId = if_abap_behv=>mk-on
                                                 OverallStatus = if_abap_behv=>mk-on ) ) ).


    it_studentsupdate = VALUE #( ( %cid_ref = 'TravelDetails'
                                    OverallStatus = 'N'
                                    %control-OverallStatus =  if_abap_behv=>mk-on ) ).


    it_flights = VALUE #( ( %tky-TravelUuid = '3E152599E70F1EDEA5F13F05E7136A0A' ) ).


    op_table = VALUE #( ( op = if_abap_behv=>op-m-create
                          entity_name = 'ZI_TRAVEL_ZUBMA'
                          instances = REF #( it_students )  )
                        ( op = if_abap_behv=>op-m-update
                          entity_name = 'ZI_TRAVEL_ZUBMA'
                          instances  = REF #( it_studentsupdate ) )
                        ( op = if_abap_behv=>op-m-delete
                          entity_name = 'ZI_TRAVEL_ZUBMA'
                          instances = REF #( it_flights ) ) ).


    MODIFY ENTITIES OPERATIONS op_table
    FAILED lt_failed
    REPORTED lt_reported
    MAPPED lt_mapped.


COMMIT ENTITIES.



  ENDMETHOD.

ENDCLASS.
