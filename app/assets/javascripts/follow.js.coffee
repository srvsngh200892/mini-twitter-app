$(document).on 'page:change', ->
  $('.js-follow').click (e) ->
      console.log "dsdsd"
      followed_id = $(this).attr('id')
      formData = {"followed_id":followed_id}
      url = "/relationships/"
      ajaxCall(formData, url , "POST")
      return


  ajaxCall = (formData, url , method)  ->
    $.ajax
      url: url
      type: method
      data: formData
      dataType: 'json'
      success: (data) ->
        $('#errorModal .error-details').html('Following Successfully')
        lwindow.location.reload(false)
        return
      error: (data) ->
        $('#errorModal .error-details').html('Something went wrong. Please refresh and try again.')
        return
    return    