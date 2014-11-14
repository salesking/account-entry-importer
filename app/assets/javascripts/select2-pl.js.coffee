###
Select2 Polish translation.

@author  Jan Kondratowicz <jan@kondratowicz.pl>
@author  Uriy Efremochkin <efremochkin@uriy.me>
###
if window.gon.locale == 'pl'
  (($) ->
    character = (n, word, pluralSuffix) ->
      " " + n + " " + word + ((if n is 1 then "" else (if n % 10 < 5 and n % 10 > 1 and (n % 100 < 5 or n % 100 > 20) then pluralSuffix else "ów")))
    "use strict"
    $.extend $.fn.select2.defaults,
      formatNoMatches: ->
        "Brak wyników"

      formatInputTooShort: (input, min) ->
        "Wpisz co najmniej" + character(min - input.length, "znak", "i")

      formatInputTooLong: (input, max) ->
        "Wpisana fraza jest za długa o" + character(input.length - max, "znak", "i")

      formatSelectionTooBig: (limit) ->
        "Możesz zaznaczyć najwyżej" + character(limit, "element", "y")

      formatLoadMore: (pageNumber) ->
        "Ładowanie wyników…"

      formatSearching: ->
        "Szukanie…"

    return
  ) jQuery
