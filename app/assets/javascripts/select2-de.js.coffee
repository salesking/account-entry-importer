###
Select2 German translation
###
if window.gon.locale == 'de'
  (($) ->
    $.extend $.fn.select2.defaults,
      formatNoMatches: ->
        "Keine Übereinstimmungen gefunden"

      formatInputTooShort: (input, min) ->
        n = min - input.length
        "Bitte " + n + " Zeichen mehr eingeben"

      formatInputTooLong: (input, max) ->
        n = input.length - max
        "Bitte " + n + " Zeichen weniger eingeben"

      formatSelectionTooBig: (limit) ->
        "Sie können nur " + limit + " Eintr" + ((if limit is 1 then "ag" else "äge")) + " auswählen"

      formatLoadMore: (pageNumber) ->
        "Lade mehr Ergebnisse…"

      formatSearching: ->
        "Suche…"

      formatMatches: (matches) ->
        matches + " Ergebnis " + ((if matches > 1 then "se" else "")) + " verfügbar, zum Navigieren die Hoch-/Runter-Pfeiltasten verwenden."

    return
  ) jQuery
