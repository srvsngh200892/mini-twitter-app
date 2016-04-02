$(document).on 'page:change', ->         
  
  $('#js-post-tweet').click (e) ->
      tweet = $("#js-tweet").val()
      formData = {"tweet":{"tweet":tweet}}
      url = "/home/tweet"
      ajaxCall(formData, url , "POST")
      return


  ajaxCall = (formData, url , method)  ->
    $.ajax
      url: url
      type: method
      data: formData
      dataType: 'json'
      success: (data) ->
        $('#errorModal .error-details').html('Tweet Posted Successful')
        location.href = '/home/home'
        return
      error: (data) ->
        $('#errorModal .error-details').html('Something went wrong. Please refresh and try again.')
        return
    return 

  $('.js-follow').click (e) ->
      followed_id = $(this).attr('id')
      formData = {"followed_id":followed_id}
      url = "/relationships"
      ajaxCallFollow(formData, url , "POST")
      return


  ajaxCallFollow = (formData, url , method)  ->
    $.ajax
      url: url
      type: method
      data: formData
      dataType: 'json'
      success: (data) ->
        $('#errorModal .error-details').html('Following Successfully')
        location.reload();
        return
      error: (data) ->
        $('#errorModal .error-details').html('Something went wrong. Please refresh and try again.')
        return
    return         