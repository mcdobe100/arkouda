module MinKReduction {
  use Heap;
  use RadixSortLSD;
  /*
   * 'mink' reduction implementation. Returns vector of k elements of type
   * eltType.
   */

  class mink : ReduceScanOp {
    type eltType;
    const k: int = 3;

    // Store minimum k items as vector in descending order.
    var v = new heap(eltType, k);

    proc identity {
      var v = new heap(eltType, k); return v;
    }

    proc accumulateOntoState(ref v, value: eltType) {
      v.pushIfSmaller(value);
    }

    proc accumulate(value: eltType) {
      accumulateOntoState(v, value);
    }

    proc accumulate(accumState: heap(eltType,int)) {
      if(accumState._data[0] == max(eltType)) {
        return;
      }
      for stateValue in accumState {
        accumulate(stateValue);
      }
    }

    proc accumulate(accumState: []) {
      for stateValue in accumState {
        accumulate(stateValue);
      }
    }

    proc combine(state: borrowed mink(eltType)) {
      //accumulate(state.v);
      v._data = merge(v, state.v);
    }

    proc generate() {
      return v;
    }

    proc clone() {
      return new unmanaged mink(eltType=eltType, k=k);
    }
  }

  proc computeMyMink(arr, kval:int) {
    var minkInstance = new unmanaged mink(eltType=int, k=kval);
    var result = minkInstance.identity;
    [ elm in arr with (minkInstance reduce result) ]
      result reduce= elm;
    delete minkInstance;
    return result;
  }

  class myMinReduce: ReduceScanOp {
    type eltType;
    var value = max(eltType);

    proc identity {
      writeln(here);
      return max(eltType);
    }
    proc accumulate(x) {
      writeln(here);
      value = min(x, value);
    }
    proc accumulateOntoState(ref state, x) {
      writeln(here);
      state = min(state, x);
    }
    proc combine(x) {
      writeln(here);
      value = min(value, x.value);
    }
    proc generate() {
      writeln(here);
      return value;
    }
    proc clone() {
      writeln(here);
      return new unmanaged myMinReduce(eltType=eltType);
    }
  }

  class regmink : ReduceScanOp {
  type eltType;
    const k: int = 10;

    // Store minimum k items as vector in descending order.                                                                                                       
    var v: [0..k] eltType = max(eltType);

    proc identity {
      var v: [0..k] eltType = max(eltType); return v;
    }

    proc accumulateOntoState(ref v, value: eltType) {
      if value <= v[v.domain.low] {
        v[v.domain.low] = value;
        for i in v.domain.low+1..#k do
          if v[i-1] < v[i] then
            v[i-1] <=> v[i];
      }
    }

    proc accumulate(value: eltType) {
      accumulateOntoState(v, value);
    }

    proc accumulate(accumState: []) {
      for stateValue in accumState {
        accumulate(stateValue);
      }
    }

    proc combine(state: borrowed regmink(eltType)) {
      accumulate(state.v);
    }

    proc generate() {
      return v;
    }

    proc clone() {
      return new unmanaged regmink(eltType=eltType, k=k);
    }
  }

  proc regcomputeMyMink(input, kval) {
    var minkInstance = new unmanaged regmink(eltType=int, k=kval);
    var result = minkInstance.identity;
    [ elm in input with (minkInstance reduce result)  ]
      result reduce= elm;
    delete minkInstance;
    return result;
  }
}
