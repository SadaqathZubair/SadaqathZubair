CLASS zcl_update_travltble DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_update_travltble IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: lt_traveldata TYPE TABLE FOR CREATE zi_travel_zubma.

    MODIFY ENTITIES OF zi_travel_zubma
    ENTITY TravelDetails
    CREATE FROM VALUE #( AgencyId = '700645'
                         BeginDate = sy-datum
                         BookingFee = '700'
                         CurrencyCode = 'INR'
                         CustomerId   = '765'
                         Description = 'Trip Flight'
                         EndDate     = sy-datum
                       (  %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                             BeginDate = if_abap_behv=>mk-on
                                             BookingFee = if_abap_behv=>mk-on
                                             CurrencyCode = if_abap_behv=>mk-on
                                             CustomerId = if_abap_behv=>mk-on
                                             Description = if_abap_behv=>mk-on
                                             EndDate     = if_abap_behv=>mk-on ) ) )
MAPPED DATA(lt_mapped)
FAILED DATA(lt_failed)
REPORTED DATA(lt_reported).


    IF lt_failed IS NOT INITIAL.

      out->write(
        EXPORTING
          data   = lt_failed
          name   = 'Failed'
*      RECEIVING
*        output =
      ).

    ELSE.

      COMMIT ENTITIES.

    ENDIF.




ENDMETHOD.

ENDCLASS.
