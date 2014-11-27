jQuery ->
  $('#reuse-select-options').on 'change', (e) -> 
    if $(this).val() <= 1
      $('#reuse').hide();
      $('#new_mapping_body').show();
    else
      $('#reuse').show();
      $('#new_mapping_body').hide();
      fillInAccountInfo($(this).val())

  fillInAccountInfo = (el) ->
    
    # clear account form
    $('#mapping_account_id').select2('data', {id: null, text: null})

    account_infos = el.split(":")
    if account_infos[1].length > 1
      $('#mapping_account_name').val(account_infos[2])
      $('#mapping_account_budget').val(account_infos[4])
      $('#mapping_account_default_price').val(account_infos[3])
      $("#mapping_account_id").select2("data", { id: account_infos[1], text: account_infos[5] }).trigger("change");;
      disableAccountInputs()
    else if account_infos[1].length < 1 && (account_infos[2].length > 1 || account_infos[3].length > 1 || account_infos[4].length > 1)
      $('#mapping_account_name').val(account_infos[2])
      $('#mapping_account_budget').val(account_infos[4])
      $('#mapping_account_default_price').val(account_infos[3])
      enableAccountInputs()
    else
      $('#mapping_account_name').val("")
      $('#mapping_account_budget').val("")
      $('#mapping_account_default_price').val("")
      enableAccountInputs()

  $('.target-fields').on 'click', '.kill', (e) -> revertField(e, this)

  $('#source-fields').delegate '.field:not(.ui-draggable)', 'mouseenter', ->
    $(this).draggable revert: 'invalid'

  $('.target-fields').delegate '.field:not(.ui-droppable)', 'mouseenter', ->
    $(this).droppable
      accept: "#source-fields li",
      hoverClass: "over",
      drop: (event, ui) -> dropField($(this), ui)

  dropField = (el, ui) ->
    addFields el, ui
    addEnumFields(el) if $('.target', el).attr('data-enum') != undefined
    addDateFields(el) if $('.target', el).attr('data-format') == 'date'
    addPriceField(el) if ['price_single', 'cost'].indexOf($('.target', el).attr('data-name')) != -1
    addBooleanFields(el) if $('.target', el).attr('data-type') == 'boolean'

  addFields = (el, ui) ->
    $('.target', el).after "<div class='source' " +
      "data-name='" + ui.draggable.data('name') + "' data-source='" + ui.draggable.data('source') + "'>" +
      "<div>" + ui.draggable.text() + "</div>" +
      "<div class='map_actions'><div class='kill'> x </div></div>" +
      "</div>"
    ui.draggable.hide()
    if $('.source', el).length > 1 && $("input[name='conversion_type']", el).length == 0
      el.append "<input name='conversion_type' type='hidden' value='join'>"
    el.addClass 'dropped'

  addPriceField = (el) ->
    if $('input[name="conversion_type"]', el).length == 0
      el.append "<input name='conversion_type' type='hidden' value='price'>"

  addEnumFields = (el) ->
    els = ["<div class='options'>"]

    $.each $('.target', el).attr('data-enum').split(','), ->
      #clean "[] from strings, comming from ary markup
      name = this.replace( /["\[\]]/g, '')
      els.push "<div> <input class='mini' name='" + name + "' type='text'> <label>=> " + name + "</label></div>"
    els.push "<input name='conversion_type' type='hidden' value='enum'>"
    els.push "</div>"
    el.append els.join('')

  addBooleanFields = (el) ->
    els = ["<div class='options'>"]
    els.push "<div> <input class='mini' name='true' type='text'> <label>=> True</label></div>"
    els.push "<div> <input class='mini' name='false' type='text'> <label>=> False</label></div>"
    els.push "<input name='conversion_type' type='hidden' value='boolean'>"
    els.push "</div>"
    el.append els.join('')

  addDateFields = (el) ->
    els = ["<div class='options'>"]
    els.push "<div> <input class='mini' name='date' type='text'> <label>=> Target format YYYY.MM.DD</label></div>"
    els.push "<div class='help-block'>Use Placeholders %Y %m %d describing the incoming date format.</div>"
    els.push "</div>"
    els.push "<input name='conversion_type' type='hidden' value='date'>"
    el.append els.join('')

  revertField = (event, el) ->
    field = $($(el).parents('.source')[0])
    parent = $($(field).parents('.field')[0])
    srcElement = $("#source-fields li[data-source=" + field.data('source') + "]")
    field.remove()
    $('.options', parent).remove()
    if $('.source', parent).length == 0
      parent.removeClass 'dropped'
      $("input[name='conversion_type']", el).remove()
    srcElement.show().css left: '', top: ''

  $('.target-fields .field').trigger 'mouseenter'

  $(':submit').click ->
    if this.id == 'reuse'
      $('form').append "<input type='hidden' name='reuse' value=true>"
    mappings = []
    $.each $('.target-fields .field.dropped'), (i) ->
      el = $(this)
      sourceIDs = [];
      $.each $('.source', el), -> sourceIDs.push $(this).attr('data-source')
      mappings.push "<input type='hidden' name='mapping[mapping_elements_attributes][" + i + "][source]' value='" + sourceIDs.join(',') + "'>"
      mappings.push "<input type='hidden' name='mapping[mapping_elements_attributes][" + i + "][target]' value='" + $('.target', el).attr('data-target') + "'>"
      mappings.push "<input type='hidden' name='mapping[mapping_elements_attributes][" + i + "][model_to_import]' value='" + $('.target', el).attr('data-model-to-import') + "'>"
      if $("input[name='conversion_type']", el).length > 0
        mappings.push "<input type='hidden' name='mapping[mapping_elements_attributes][" + i + "][conversion_type]' value='" + $("input[name='conversion_type']", el).val() + "'>"
      if $('.options', el).length > 0
        opts = {};
        $.each $('.options :text', el), -> opts[$(this).attr('name')] = $(this).val()
        mappings.push "<input type='hidden' name='mapping[mapping_elements_attributes][" + i + "][conversion_options]' value='" + JSON.stringify(opts) + "'>"
    $('form').append mappings.join('')

  $('input[name="mapping[import_type]"]').click ->
    $doc_id = $("#mapping_account_id")
    if $(this).val() == 'line_item'
      $doc_id.select2('enable', true)
    else
      removeSelectValue($doc_id)
      $doc_id.select2('enable', false)

  $('input[name="mapping[document_type]"]').change ->
    removeSelectValue("#mapping_account_id")

  $("#mapping_account_id").select2
    placeholder: window.gon.account_id_placeholder
    minimumInputLength: 1
    allowClear: true
    quietMillis: 100
    width: 350
    initSelection: (element, callback) ->
      data = {id: element.val(), text: element.val()}
      callback(data)
    ajax:
      url: "/accounts.json"
      dataType: "json"
      data: (term, page) ->
        q: term
        type: "account"
        per_page: 10
        page: page

      results: (data, page) ->
        results: data.results
        more: (page < data.total_pages)

    formatResult: (doc) ->
      doc.number + ' - ' + doc.name
    formatSelection: (doc) ->
      doc.number
    escapeMarkup: (m) ->
      m

  $('#mapping_account_id').on "select2-selecting", (e) ->
    if e.object != undefined
      $('#mapping_account_name').val(e.object.name)
      $('#mapping_account_budget').val(e.object.budget)
      $('#mapping_account_default_price').val(e.object.default_price)
      disableAccountInputs()
    else


    $('#document_attributes').hide()


  $('#clear_document_choser').on 'click', (e) ->
    $('#mapping_account_id').select2('data', {id: null, text: null})
    $('#mapping_account_name').val("")
    $('#mapping_account_budget').val("")
    $('#mapping_account_default_price').val("")
    enableAccountInputs()

  $('#radio_document').on 'click', (e) ->
    $('#radio_document')
    $('#document_attributes').show()

  $('#radio_line_item').on 'click', (e) ->
    $('#document_attributes').hide()

  disableAccountInputs = () ->
    $('#mapping_account_name').prop('readonly', true);
    $('#mapping_account_budget').prop('readonly', true)
    $('#mapping_account_default_price').prop('readonly', true)

  enableAccountInputs = () ->
    $('#mapping_account_name').prop('readonly', false)
    $('#mapping_account_budget').prop('readonly', false)
    $('#mapping_account_default_price').prop('readonly', false)

removeSelectValue = (el) ->
  $(el).val('')
  $(el).select2('val', '')
