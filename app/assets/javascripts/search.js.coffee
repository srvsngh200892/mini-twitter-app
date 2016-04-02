$(document).on 'page:change', ->

  clear = ->
    $('.tableClass').addClass('hide')
    $('.tableClass tbody').html('')
    return

  searchUserPartialDataTableFunction = (data, userData) ->
    $('.searchUserPartialDataTable').on("click", ".viewLastOrder",(e) ->
      $(location).attr('href',$(this).attr('data-link'))
      return
    ).dataTable
      aoColumnDefs: [
        {
          aTargets: [0]
          mRender: (data, type, row) ->
            
            '<a href="/users/'+row[1]+'">'+data+'</a>'
        }

        {
          aTargets: [1]
          mRender: (data, type, row) ->
            console.log row
            if ($.inArray(row[1], row[2]) != -1)
              '<a data-link="" class="btn btn-success disabled">Following</a>'
              
            else
              '<a data-link="" class="btn btn-success js-follow", id='+row[1]+'>Follow</a>'
              
        }
      ]
      destroy: true
      data: userData
    return
  
  getSearchResults = () ->
    $('.userSpace').addClass('hide')
    $('.loading').removeClass('hide')
    form_data = "query="+$(".searchForm .searchBox").val()
    noResults = true
    data = JSON.parse($("#resultsData").text().trim())
    clear()
    $('.loading').addClass('hide')
    if Object.keys(data.users).length != 0
      userData = createUserData(data.users)
      searchUserPartialDataTableFunction(data.users,userData)
      $('#searchUserTable').removeClass('hide')
      noResults = false
    if data.users.length != 0
      tweetSearchResult(data)
      $('#searchOrderTable').removeClass('hide')
      noResults = false
    if noResults
      $('.noResults').removeClass('hide')
    return

  window.createUserData = (data) ->
    userData = []
    $.each data, (key, user) ->
      rowData = []
      first_name = user.user_info.first_name or ''
      last_name = user.user_info.last_name or ''
      rowData.push first_name+' '+last_name
      rowData.push user.user_info.id
      rowData.push user.followers
      userData.push rowData

      return
    return userData  


  tweetSearchResult = (data) ->
    orderData = []
    $.each data.tweets, (key, tweet) ->
      rowData = []
      rowData.push tweet.tweet
      
      
      orderData.push rowData
    $('#searchTweetDataTable').dataTable
      aoColumnDefs: [
        {
          aTargets: [0]
          mRender: (data, type, row) ->
            '<a href="">'+data+'</a>'
        }
      ]
      destroy: true
      data: orderData
    return

  if $("#resultsData").text() isnt ""
    getSearchResults()
    return