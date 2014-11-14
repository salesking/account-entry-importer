jQuery ->
  $('tbody .check-column :checkbox').img_checkbox();

  $('#csv-refresh').click ->
    $.ajax
      url: $('#new_attachment').attr('action'),
      type: 'POST',
      dataType: 'json',
      data:
        '_method': 'put',
        'attachment[column_separator]': $('#attachment_column_separator').val(),
        'attachment[quote_character]': $("#attachment_quote_character").val(),
        'attachment[encoding]': $("#attachment_encoding").val()
      ,
      success: (data) -> insertFields(data)
    false

  if $('#file-upload').length > 0
    uploader = new qq.FileUploader
      multiple: false,
      element: document.getElementById("file-upload"),
      action: '/attachments',
      allowedExtensions: ["txt", "csv"],
      sizeLimit: 5048576,
      onSubmit: (id, fileName) ->
        uploader.setParams
          authenticity_token: $("input[name='authenticity_token']").val()
          column_separator: $("#attachment_column_separator").val()
          quote_character: $("#attachment_quote_character").val()
          encoding: $("#attachment_encoding").val()
      ,
      onComplete: (id, fileName, data) ->
        insertFields(data)
        showFileName()
        $('#continue-button').show();
        $('#new_attachment').attr('action', '/attachments/' + data.id)

  insertFields = (data) ->
    csv = ['<table class="table">']
    $.each data.rows, (index, row) ->
      if index == 0
        csv.push '<thead>'
        csv.push '<tr>'  
        $.each row, (index, value) -> csv.push('<th>' + (if value then value else '') + '</th>') 
        csv.push '</tr>'
        csv.push '</thead>'
        csv.push '<tbody>'
      if index > 0
        csv.push '<tr>'
        $.each row, (index, value) -> csv.push('<td>' + (if value then value else '') + '</td>')
        csv.push '</tr>'
    csv.push '</tbody>'
    csv.push '</table>'
    $('#csv-table table').remove()
    $('#csv-table').show().append csv.join('')

  showFileName = () ->
    file_name = $('.qq-upload-file').val();
    file_size = $('qq-upload-size').val();

    $('#csv-table h2').append(file_name);

  $(document).ready ->
    button_text = $('#button-locale').text();
    input = $('.qq-upload-button').find("input");
    $('.qq-upload-button').text(button_text);
    $('.qq-upload-button').append(input);