CLASS zcl_bookingdiscount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bookingdiscount IMPLEMENTATION.



  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_data TYPE STANDARD TABLE OF zc_travel_zub WITH DEFAULT KEY.

    lt_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_original_data>).

      IF <ls_original_data> IS ASSIGNED AND <ls_original_data>-bookingfee GE '1000'.

        <ls_original_data>-BonusDiscount = <ls_original_data>-TotalPrice - 300.

      ENDIF.

      ct_calculated_data = CORRESPONDING #( lt_data ).

    ENDLOOP.



  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
