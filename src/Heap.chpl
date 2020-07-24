/*
 * Max heap
 */

module Heap {
  use SymArrayDmap;
  use Sort;
  record heap {
    type eltType;
    var size;
    var dom = {0..#size};
    var _data: [dom] eltType = max(eltType);
    var isSorted: bool = false;

    proc pushArr(arr: [?D]) {
      for i in D {
        pushIfSmaller(arr[i]);
      }
    }

    // Drop value if too big
    proc pushIfSmaller(val: eltType) {
      if(val < _data[0]) {
        _data[_data.domain.low] = val;
        heapifyDown();
      }
    }

    proc heapifyDown() {
      var i = _data.domain.low;
      while(i < size) {
        var gi = i*2;
        if(gi > _data.domain.high) then break;
        if(gi + 1 <= _data.domain.high) {
          if(_data[gi+1] > _data[gi]) {
            gi += 1;
          }
        }
        if(_data[gi] > _data[i]) {
          _data[gi] <=> _data[i];
          i = gi;
        }
        else break;
      }
    }

    iter these() {
      for e in _data {
        yield e;
      }
    }
  }//end heap

  // Sort both heaps and then merge them
  // returns an array that contains the
  // smallest values from each array sorted.
  // Returned array is size of the original heaps.
  proc merge(ref heap1: heap(int, int), ref heap2: heap(int, int)): [heap1._data.domain] int {
    ref first = heap1._data;
    ref second = heap2._data;
    if !heap1.isSorted then sort(first);
    if !heap2.isSorted then sort(second);
    var ret: [first.domain] heap1.eltType;
    var a,b: int = 0;
    for i in ret.domain {
      if(first[a] < second[b]) {
        ret[i] = first[a];
        a += 1;
      } else {
        ret[i] = second[b];
        b += 1;
      }
    }
    return ret;
  }
}
