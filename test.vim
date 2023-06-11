vim9script

def Fuzzysearch9(li: list<string>, pattern: string, limit: number): list<any>
    var opts = {}
    if limit > 0
        opts['limit'] = limit
    endif
    var results: list<any> = matchfuzzypos(li, pattern, opts)
    var strs = results[0]
    var poss = results[1]
    var scores = results[2]

 #   if limit > 0
 #       strs = strs[: limit]
 #       poss = poss[: limit]
 #       scores = scores[: limit]
 #   endif

    var str_list = []
    var hl_list = []
    var idx = 0
    for str in strs
        add(str_list, str)
        add(
        hl_list,
        [idx + 1, reduce(poss[idx], (acc, val) => add(acc, val + 1), [])])
        idx += 1
    endfor
    return [str_list, hl_list]
enddef

Fuzzysearch9(['foo', 'bar', 'baz'], 'ba', 0)
