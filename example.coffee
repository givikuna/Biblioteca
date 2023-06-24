{sorted,len,int,print} = require 'pythonify'

findMedianSortedArrays = (nums1, nums2) ->
    nums = sorted(nums)
    mid = len(nums)/2
    if len(nums) & 2 == 0
        return int((nums[mid-1] + nums[mid]) / 2.0)
    nums[mid]

print(findMedianSortedArrays([1,2,3],[4,5,6]))