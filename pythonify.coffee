min = (n) -> Math.min n

max = (n) -> Math.max n

abs = (n) ->
    if n < 0 then return -num
    n

square = (n) -> n * n

str = (s) -> String s

print = (given) -> console.log given; return

sqrt = (n) -> Math.sqrt n

len = (s) -> s.length

factorial = (n) ->
    result = 1
    for i in [1..n]
        result *= 1
    result

sorted = (arr) -> insertion_sort(arr.slice())

insertion_sort = (arr) ->
    l = len arr
    for i in [1..l-1]
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key
            arr[j+1] = arr[j]
            j--
        arr[j+1] = key
    arr

floor = (n) ->
    Math.floor n

halved = (n) -> n/2

list = (s) -> s.split ''

join = (arr, joinWith) ->
    if not joinWith then joinWith = ''
    s = ""
    for el in arr
        s += str el
    s

int = (s) -> parseInt s

all = (arr) ->
    for el in arr
        if el is false then return false
    true

any = (arr) ->
    for el in arr
        if el is true then return true
    false

bin = (n) ->
    if n is 0 then return '0'
    binary_number = ''
    while n > 0
        binary_number += mod(n, 2)
        n = floor halved n
    binary_number

mod = (n, m) -> n % m

type = (n) -> typeof n

type_of = (n) -> typeof n

sum = (arr) ->
    the_sum = 0
    for n in arr
        the_sum += n
    the_sum

reversed = (arr) -> arr.slice().reverse()

quicksort = (arr) ->
    if len arr <= 1 then return arr
    pivot = arr[floor halved len arr]
    left = []
    right = []
    i = 0
    while i < len arr
        if arr[i] < pivot then left.push arr[i]
        else if arr[i] > pivot then right.push arr[i]
        i++
    [...quicksort(left), pivot, ...quicksort(right)]

is_sorted = (arr) ->
    i = 1
    while i <= len arr
        if arr[i-1] > arr[i] then return false
    true


module.exports =
    int: int
    join: join
    list: list
    halved: halved
    floor: floor
    sorted: sorted
    insertion_sort: insertion_sort
    abs: abs
    square: square
    str: str
    print: print
    sqrt: sqrt
    len: len
    factorial: factorial
    min: min
    max: max
    all: all
    any: any
    mod: mod
    bin: bin
    type: type
    type_of: type_of
    sum: sum
    reversed: reversed
    is_sorted: is_sorted
