module Heap {
  use SymArrayDmap;
  use Sort;
  record heap {
    type eltType;
    var size;
    var dom = domain(1);
    var _data: [dom] eltType;

    proc init(type eltType, size: int) {
      this.eltType = eltType;
      this.size = size;
      dom = {0..#size};
      _data = max(eltType);
    }

    proc pushArr(arr: [?D]) {
      for i in D {
        pushIfSmaller(arr[i]);
      }
    }

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

  proc merge(heap1: heap(int, int), heap2: heap(int, int)): [heap1._data.domain] int {
    var first = heap1._data;
    var second = heap2._data;
    sort(first);
    sort(second);
    var temp: [heap1._data.domain] heap1.eltType;
    var a: int = first.domain.low;
    var b: int = second.domain.low;
    for i in temp.domain {
      if(a < b) {
        temp[i] = first[a];
        a += 1;
      } else {
        temp[i] = second[b];
        b += 1;
      }
    }
    return temp;
  }
}//end module