/*
 * Min or max heap data structure implementation
 */

module Heap {
  use SymArrayDmap;
  use Sort;
  record heap {
    type eltType;
    var size;
    var dom = domain(1);
    var isMax: bool;
    var _data: [dom] eltType;

    proc init(type eltType, size: int, isMax=true) {
      this.eltType = eltType;
      this.size = size;
      dom = {0..#size};
      this.isMax = isMax;
      if isMax then _data = max(eltType); else _data = min(eltType);
    }

    proc pushArr(arr: [?D]) {
      for i in D {
        push(arr[i]);
      }
    }

    // Drop value if not needed, push otherwise
    proc push(val: eltType) {
      ref tmp = _data[_data.domain.low];
      const shouldAdd = if isMax then val<tmp else val>tmp;
      if shouldAdd {
        tmp = val;
        heapifyDown();
      }
    }

    proc heapifyDown() {
      var i = _data.domain.low;
      while(i < size) {
        var gi = i*2;
        if(gi > _data.domain.high) then break;
        if(gi + 1 <= _data.domain.high) {
          const cmp = if isMax then _data[gi+1]>_data[gi] else _data[gi+1]<_data[gi];
          if(cmp) {
            gi += 1;
          }
        }
        const cmp = if isMax then _data[gi]>_data[i] else _data[gi]<_data[i];
        if(cmp) {
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
  // Returned array is size of one of the original heaps.
  proc merge(heap1: heap(int, int), heap2: heap(int, int)): [heap1._data.domain] int {
    const isMaxHeap: bool = heap1.isMax;
    var first = heap1._data;
    var second = heap2._data;
    sort(first);
    sort(second);
    var ret: [heap1._data.domain] heap1.eltType;
    var a: int = if isMaxHeap then first.domain.low else first.domain.high;
    var b: int = if isMaxHeap then second.domain.low else second.domain.high;
    for i in ret.domain {
      var cmp = if isMaxHeap then first[a] < second[b] else first[a] > second[b];
      if(cmp) {
        ret[i] = first[a];
        a += if isMaxHeap then 1 else -1;
      } else {
        ret[i] = second[b];
        b += if isMaxHeap then 1 else -1;
      }
    }
    return ret;
  }
}
