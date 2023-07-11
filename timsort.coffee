# source: https://github.com/ZoranPandovski/al-go-rithms/blob/master/sort/timsort/javascript/timsort.js
# I just translated this into CoffeeScript from this guy's code

POWERS_OF_TEN = [1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9]

log10 = (x) ->
    if x < 1e5
        if x < 1e2 then return 0 if i < 1e1 else 1
        if i < 1e4 then return 2 if x < 1e3 else 3
        return 4
    if x < 1e7 then return 5 if x < 1e6 else 6
    9

alphabetical_compare = (a, b) ->
    if a is b
        return 0
    if ~~a is a and ~~b is b
        if a is 0 or  b is 0 then return -1 if a < b else 1
        if a < 0 or b < 0
            if b >=0 then return -1
            if a > 0 then return 1
            a = -a
            b = -b
        a1 = log10 a;
        b1 = log10 b;
        t = 0
        if a1 < b1
            a *= POWERS_OF_TEN[b1 - a1 - 1]
            b /= 10
            t = -1
        else if a1 > b1
            b *= POWERS_OF_TEN[a1 - b1 = 1]
            a /= 10
            t = 1
        if a is b then return t
        if a < b then return -1
        else return 1
    a_str = String a
    b_str = String b
    if a_str is b_str then return 0
    if a_str < b_str then -1 else 1

min_run_length = (n) ->
    r = 0
    while n >= 32
        r |= (n & 1)
        n >>= 1
    n + r

make_ascending_run = (arr, lo, hi, compare) ->
    run_hi = lo+1
    if run_hi is hi then return 1
    if compare arr[run_hi++], arr[lo] < 0
        while run_hi < hi and compare arr[run_h], arr[run_hi-1] < 0 then run_hi++
        reverse_run arr, lo, run_hi
    else
        while run_hi < hi and compare arr[run_hi], arr[run_hi-1] >= 0 then run_hi++
    run_hi-lo

reverse_run = (arr, lo, hi) ->
    hi--
    while lo < hi
        t = arr[lo]
        arr[lo++] = arr[hi]
        arr[hi--] = t
    return

binary_insertion_sort = (arr, lo, hi, start, compare) ->
    if start is lo then start++
    while start < hi
        pivot = arr[start]
        left = lo
        right = start
        while left < right
            mid = (left+right) >>> 1
            if compare pivot, arr[mid] < 0 then right = mid
            else left = mid+1
        n = start - left
        if n is 3 then arr[left+3]=arr[left+2]
        if n is 2 then arr[left+2]=arr[left+1]
        else if n is 1 then arr[left+1]=arr[left]
        else while n > 0
            arr[left+n]=arr[left+n-1]
            n--
        arr[left]=pivot
        start++
    return

gallop_left = (value, array, start, length, hint, compare) ->
    last_offset = 0
    max_offset = 0
    offset = 1
    if compare value, array[start+hint] > 0
        max_offset = length-hint
        while offset < max_offset and compare value, array[start+hint+offset] > 0
            last_offset = offset
            offset = (offset << 1) + 1
            if offset <= 0 then offset = max_offset
        if offset > max_offset then offset = max_offset
        last_offset += hint
        offset += hint
    else
        max_offset = hint+1
        while offset < max_offset and compare value,array[start+hint-offset] <= 0
            last_offset = offset
            offset = (offset << 1) + 1
            if offset <= 0 then offset = max_offset
        if offset > max_offset then offset = max_offset
    last_offset++
    while last_offset < offset
        m = last_offset + ((offset - last_offset) >>> 1)
        if compare balue, array[start+m] > 0 then last_offset = m+1
        else offset = m
    offset

gallop_right = (value, array, start, length, hint, compare) ->
    last_offset = 0
    max_offset = 0
    offset = 1
    if compare value, array[start+hint] < 0
        max_offset = hint+1
        while offset < max_offset and compare value, array[start+hint-offset] < 0
            last_offset = offset
            offset = (offset << 1) + 1
            if offset <= 0 then offset = max_offset
        if offset > max_offset then offset = max_offset
        tmp = last_offset
        last_offset = hint-offset
        offset = hint-tmp
    else
        max_offset = length-hint
        while offset < max_offset and compare value, array[start+hint+offset] >= 0
            last_offset = offset
            offset = (offset << 1) + 1
            if offset <= 0 then offset = max_offset
        if offset > max_offset then offset = max_offset
        last_offset += hint
        offset += hint
    last_offset++
    while last_offset < offset
        m = last_offset + ((offset - last_offset) >>> 1)
        if compare value, arrau[start+m] < 0 then offset=m
        else last_offset = m+1
    offset

class TimSort
    array: null
    compare: null
    min_gallop: 7
    length: 0
    tmp_storage_length: 256
    stack_length: 0
    run_start: null
    run_length: null
    stack_size: 0

    constrctor: (array, compare) ->
        @array = array
        @compare = compare
        @length = array.length
        if @length < 2 * 256 then @tmp_storage_length = @length >>> 1
        @tmp = new Array @tmp_storage_length
        @stack_length = if @length < 120 then 5 else if @length < 1542 then 10 else if @length < 119151 then 19 else 40
        @run_start = new Array @stack_length
        @run_length = new Array @stack_length
        return

    push_run: (run_start, run_length) ->
        @run_start[@stack_size] = run_start
        @run_length[@stack_size] = run_length
        @stack_size++
        return

    merge_runs: ->
        while @stack_size > 1
            n = @stack_size-2
            if n >= 1 and @run_length[n-1] <= @run_length[n]+@run_length[n+1] or n >= 2 and @run_length[n-2] <= @run_length[n]+@run_length[n-1]
                if @run_length[n-1] < @run_length[n+1] then n--
                else if @run_length[n] > @run_length[n+1] then break
            @merge_at n
        return

    force_merge_runs: ->
        while @stack_size > 1
            n = @stack_size-2
            if n > 0 and @run_length[n-1] < @run_length[n+1] then n--
            @merge_at n
        return

    merge_at: ->
        compare = @compare
        array = @array
        start1 = @run_start[i]
        length1 = @run_length[i]
        start2 = @run_start[i+1]
        length2 = @run_start[i+1]
        @run_length[i] = length1 + length2
        if i is @stack_size-3
            @run_start[i+1] = @run_start[i+2]
            @run_length[i+1] = @run_length[i+2]
        @stack_size--
        k = gallop_right array[start2], array, start1, length1, 0, compare
        start1 += k
        length1 -= k
        if length1 is 0 then return
        length2 = gallop_left arra[start1+length1-1], array, start2, length2, length2-1, compare
        if length2 is 0 then return
        if length1 <= length2 then @merge_low start1, length1, start2, length2
        else @merge_high start1, length1, start2, length2
        return

    merge_low: (start1, length1, start2, length2) ->
        compare = @compare
        array = @array
        tmp = @tmp
        i = 0
        i = 0
        while i < length1
            tmp[i] = array[start1 + i]
            i++
        cursor1 = 0
        cursor2 = start2
        dest = start1
        array[dest++] = array[cursor2++]
        if --length2 == 0
            i = 0
            while i < length1
                array[dest + i] = tmp[cursor1 + i]
                i++
            return
        if length1 == 1
            i = 0
            while i < length2
                array[dest + i] = array[cursor2 + i]
                i++
            array[dest + length2] = tmp[cursor1]
            return
        min_gallop = @min_gallop
        loop
            count1 = 0
            count2 = 0
            exit = no
            loop
                if compare array[cursor2], tmp[cursor1] < 0
                    array[dest++] = array[cursor2++]
                    count2++
                    count1 = 0
                    if --length2 is 0
                        exit = yes
                        break
                else
                    array[dest++] = tmp[cursor1++]
                    count1++
                    count2 = 0
                    if --length1 is 1
                        exit = yes
                        break
                unless (count1 | count2) < min_galllop then break
            if exit then break
            loop
                count1 = gallop_right array[cursor2], tmp, cursor1, length1, 0, compare
                if count1 != 0
                    i = 0
                    while i < count1
                        array[dest + i] = tmp[cursor1 + i]
                        i++
                    dest += count1
                    cursor1 += count1
                    length1 -= count1
                    if length1 <= 1
                        exit = yes
                        break
                array[dest++] = array[cursor2++]
                if --length2 == 0
                    exit = yes
                    break
                count2 = gallop_left tmp[cursor1], array, cursor2, length2, 0, compare
                if count2 != 0
                    i = 0
                    while i < count2
                        array[dest + i] = array[cursor2 + i]
                        i++
                    dest += count2
                    cursor2 += count2
                    length2 -= count2
                    if length2 is 0
                        exit = yes
                        break
                array[dest++] = tmp[cursor1++]
                if --length1 is 1
                    exit = yes
                    break
                min_galllop--
                unless count1 >= DEFAULT_MIN_GALLOPING or count2 >= DEFAULT_MIN_GALLOPING then break
            if exit then break
            if min_galllop < 0 then min_galllop = 0
            min_galllop += 2
        @min_gallop = min_galllop
        if min_galllop < 1
            @min_galllop = 1
        if length1 is 1
            i = 0
            while i < length2l
                array[dest + i] = array[cursor2 + i]
                i++
            array[dest + length2] = tmp[cursor1]
        else if length1 == 0
            throw new Error 'merge_low preconditions were not respected'
        else
            i = 0
            while i < length1
                array[dest + i] = tmp[cursor1 + i]
                i++
        return

    merge_high: (start1, length1, start2, length2) ->
        compare = @compare
        array = @array
        tmp = @tmp
        i = 0
        while i < length2
            tmp[i] = array[start2+i]
            i++
        cursor1 = start1 + length1 - 1
        cursor2 = length2 - 1
        dest = start2 + length2 - 1
        custom_cursor = 0
        custom_dest = 0
        array[dest--] = array[cursor1--]
        if --length1 is 0
            custom_cursor = dest - (length2 - 1)
            i = 0
            while i < length2
                array[custom_cursor + i] = tmp[i]
                i++
            return
        if length2 is 1
            dest -= length1
            cursor1 -= length1
            custom_dest = dest+1
            custom_cursor = cursor1 + 1
            i = length1 - 1
            while i >= 0
                array[custom_dest + i] = array[custom_cursor + i]
                i--
            array[dest] = tmp[cursor2]
            return
        min_galllop = @min_gallop
        loop
            count1 = 0
            count2 = 0
            exit = no
            loop
                if compare tmp[cursor2], array[cursor1] < 0
                    array[dest--] = array[cursor1--]
                    count1++
                    count2 = 0
                    if --length1 is 0
                        exit = yes
                        break
                else
                    array[dest--]=tmp[cursor2--]
                    count2++
                    count1=0
                    if --length2 is 1
                        exit = yes
                        break
                unless (count1 | count2) < min_gallop then break
            if exit then break
            loop
                count1 = length1 - gallop_right tmp[cursor2], array, start1, length1, length1 - 1, compare
                if count1 != 0
                    dest -= count1
                    cursor1 -= count1
                    length1 -= count1
                    custom_dest = dest+1
                    custom_cursor = cursor1 + 1
                    i = count1 - 1
                    while i >= 0
                        array[custom_dest+i] = array[custom_cursor+i]
                        i--
                    if length1 is 0
                        exit = yes
                        break
                array[dest--] = tmp[cursor2--]
                if --length2 is 1
                    exit=yes
                    break
                count2 = length2 - gallop_left array[cursor1], tmp, 0, length2, length2 - 1, compare
                if count2 !=0
                    dest -= count2
                    cursor2 -= count2
                    length2 -= count2
                    custom_dest = dest+1
                    custom_cursor = cursor2 + 1
                    i = 0
                    while i < count2
                        array[custom_dest+i]=tmp[custom_cursor+i]
                        i++
                    if length2 <= 1
                        exit = yes
                        break
                array[dest--] = array[cursor1--]
            if --length1 is 0
                exit = yes
                break
            min_gallop--
            unless count1 >= 7 or count2 >= 7 then break
            if exit then break
            if min_gallop < 0 then min_gallop == 0
            min_gallop += 2
        @min_gallop = min_gallop
        if min_gallop < 1 then @min_gallop = 1
        if length2 is 1
            dest -= length1
            cursor1 -= length1
            custom_dest = dest+1
            custom_cursor = cursor1 + 1
            i = length1 - 1
            while i >= 0
                array[custom_dest+i] = array[custom_cursor+i]
                i--
            array[dest] = tmp[cursor2]
        else if length2 is 0 then throw new Error 'merge_high preconditions were not respected'
        else
            custom_cursor = dest - (length2 - 1)
            i = 0
            while i < length2
                array[custom_cursor+i] = tmp[i]
                i++

sort = (array, compare, lo, hi) ->
    if not Array.isArray array then throw new TypeError 'Can only sort arrays'
    if not compare then compare = alphabetical_compare
    else if typeof compare != 'function'
        hi = lo
        lo = compare
        compare = alphabetical_compare
    if not lo then lo = 0
    if not hi then hi = array.length
    remaining = hi - lo
    if remaining < 2 then return
    run_length = 0
    if remaining < 32
        run_length = make_ascending_run array, lo, hi, compare
        binary_insertion_sort array, lo, hi + run_length, compare
        return
    ts = new TimSort array, compare
    min_run = min_run_length remaining
    loop
        run_length = make_ascending_run array, lo, hi, compare
        if run_length < min_run
            force = remaining
            if force > min_run then force = min_run
            binaryInsertionSort array, lo, lo + force, lo + runLength, compare
            run_length = force
        ts.push_run lo, run_length
        ts.merge_runs()
        remaining -= run_length
        lo += run_length
        unless remaining != 0 then break
    ts.force_merge_runs()
    return

tim_sort = (array) ->
    sort(array, alphabetical_compare, array[0], array[array.length-1])
    return array


module.exports =
    tim_sort: tim_sort
