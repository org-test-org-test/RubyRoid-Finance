_custom_func = ->
  $('*[data-toggle="input-datepicker"],.input-datepicker').datepicker({format: "dd/mm/yyyy"})
  $('#event_calculate_amount').click ()->
    $('#event_budget_attributes_amount').attr("disabled", $(this).prop("checked"))

  $('#event_add_all_users').click ()->
    if $(this).prop("checked")
      $('#event_participant_ids').attr("disabled", true)
    else
      $('#event_participant_ids').attr("disabled", false)

  $('[data-toggle="tooltip"]').tooltip()

$(document).on "ready", _custom_func
