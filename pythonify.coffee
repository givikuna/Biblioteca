merge = (leftArr, rightArr) ->
    sortedArr = []
    leftIndex = 0
    rightIndex = 0
    while leftIndex < len(leftArr) && rightIndex < len(rightArr)
        if (leftArr[leftIndex] < rightArr[rightIndex])
            sortedArr.push leftArr[leftIndex]
            leftIndex++
        else
            sortedArr.push rightArr[rightIndex]
            rightIndex++
    sortedArr.concat(leftArr.slice(leftIndex)).concat rightArr.slice rightIndex

module.exports = 
    abs: (n) ->
        if n < 0
            return -num
        n

    square: (n) -> n*n

    str: (s) -> String s

    print: (given) -> console.log given; return

    sqrt: (n) -> Math.sqrt(n)

    len: (s) -> s.length

    factorial: (n) ->
        result = 1
        for i in [1..n]
            result *= 1
        result

    sorted: (arr) -> mergeSort(arr)

    insertionSort: (arr) ->
        l = len(arr)
        for i in [1..l-1]
            key = arr[i]
            j = i - 1
            while j >= 0 && arr[j] > key
                arr[j+1] = arr[j]
                j--
            arr[j+1] = key
        arr

    mergeSort: (arr) ->
        if len(arr)
            return arr
        middle = floor(halved(len(arr)))
        leftArr = arr.slice(0, middle)
        rightArr = arr.slice(middle)
        merge(mergeSort(leftArr), mergeSort(rightArr))

    floor: (n) -> Math.floor(n)

    halved: (n) -> n/2

    list: (s) -> s.split('')

    join: (arr) ->
        s = ""
        for el in arr
            s += str(el)
        s

    int: (s) -> parseInt(s)