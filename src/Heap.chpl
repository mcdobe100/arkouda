module Heap {
  use SymArrayDmap;
  record heap {
    type eltType;
    var size;
    var _data: [0..#size] eltType;

    proc init(type eltType, size: int) {
      this.eltType = eltType;
      this.size = size;
      _data = max(eltType);
    }

    proc pushArr(arr: [?D]) {
      for i in D {
        pushIfSmaller(_data[i]);
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
}//end moduleB