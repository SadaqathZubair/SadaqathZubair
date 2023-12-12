CLASS lhc_ZI_TRAVEL_ZUBATCH DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_zubatch RESULT result.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_ZUBATCH IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
