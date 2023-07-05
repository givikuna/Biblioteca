readline = require 'readline'

min = (n) -> Math.min n

max = (n) -> Math.max n

abs = (n) ->
    if n < 0 then return -n
    n

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

type = (n) -> typeof n

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

ascii = (txt) ->
    [...txt].map((char) ->
        if char.charCodeAt(0) > 127 then return '\\u'+char.charCodeAt(0).toString(16).padStart 4, '0'
        return char).join ''

bool = (val) -> !!val

chr = (val) -> String.fromCharCode(val)

callable = (obj) -> typeof obj is 'function'

complex = (real, imaginary=0) ->
    if typeof real is not 'number' or typeof imaginary is not 'number' then throw new TypeError 'Both real and imaginary parts must be numbers'
    {
        real,
        imaginary,
        toString: ->
            if this.imaginary is 0 then return str(this.real)
            else if this.real is 0 then return this.imaginary+'j'
            else if this.imaginary > 0 then return this.real+' + '+this.imaginary+'j'
            else return this.real+' - '+abs(this.imaginary)+'j'
    }

delattr = (obj, attr) ->
    if typeof obj is not 'object' then throw new TypeError 'Object expected'
    if typeof attr is not 'string' then throw new TypeError 'Attribute name must be a string'
    if attr not in obj then throw new TypeError 'Attribute '+attr+' does not exist'
    delete obj[attr]

divmod = (a, b) -> a % b

zip = (...arrays) ->
    result = []
    minLength = min(...arrays.map (arr) -> len(arr))
    i = 0
    while i < minLength
        tuple = arrays.map (arr) -> arr[i]
        result.push(tuple)
        i++
    result

pow = (base, exponent) -> Math.pow base, exponent

hex = (n) -> n.toString 16

input = (prompt) -> # async function, need to use await
    rl = readline.createInterface {
        input: process.stdin,
        output: process.stdout
    }
    new Promise (resolve, reject) ->
        rl.question prompt, (inputted) ->
            rl.close()
            resolve(inputted)

module.exports =
    ascii: ascii
    chr: chr
    bool: bool
    callable: callable
    complex: complex
    delattr: delattr
    divmod: divmod
    zip: zip
    pow: pow
    hex: hex
    input: input
    int: int
    join: join
    list: list
    halved: halved
    floor: floor
    sorted: sorted
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
    sum: sum
    reversed: reversed
