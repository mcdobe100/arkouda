/*
 * kextreme data structure that is used
 * to track the minimum or maximum `size`
 * values that are in an array. Acts similar
 * to a heap data structure, but can be
 * sorted and merged to extract the
 * extreme values from multiple kextreme
 * objects.
 */

module KExtreme {
  use SymArrayDmap;
  use Sort;
  record kextreme {
    type eltType;
    var size: int;
    var dom = {0..#size};
    var numEmpty: int = size-1;
    var _data: [dom] eltType = max(eltType);
    var isSorted: bool = false;

    proc pushArr(arr: [?D]) {
      for i in D {
        push(arr[i]);
      }
    }

    // Push a value into the kextreme
    // instance, only pushes a value if
    // it is an encountered extreme
    proc push(val: eltType) {
      if(numEmpty > 1 && _data[0] == max(eltType)) {
        _data[numEmpty] = val;
        numEmpty-=1;
      } else if val < _data[0] {
        _data[0] = val;
        heapifyDown();
      }
    }

    // Restore heap property from the
    // top element down
    proc heapifyDown() {
      var i = 0;
      while(i < size) {
        var gi = i*2;
        if(gi > size-1) then break;
        if(gi + 1 <= size-1) {
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
  proc merge(ref v1: kextreme(int), ref v2: kextreme(int)): [v1._data.domain] int {
    ref first = v1._data;
    ref second = v2._data;
    if !v1.isSorted {
      sort(first);
      v1.isSorted = true;
    }
    if !v2.isSorted {
      sort(second);
      v2.isSorted = true;
    }
    var ret: [first.domain] v1.eltType;
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