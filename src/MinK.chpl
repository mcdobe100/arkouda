/*
 * 'mink' reduction implementation. Returns 
 * vector of k elements of type eltType.
 */

module MinK {
  use Heap;
  use RadixSortLSD;
  
  class minormaxk : ReduceScanOp {
    type eltType;
    const k: int;
    const isMinK: bool;

    // create a new heap per task
    var v = new heap(eltType, k, isMinK);

    proc identity {
      var v = new heap(eltType, k, isMinK); return v;
    }

    proc accumulateOntoState(ref v, value: eltType) {
      v.push(value);
    }

    proc accumulate(value: eltType) {
      accumulateOntoState(v, value);
    }

    proc accumulate(accumState: heap(eltType,int)) {
      for stateValue in accumState {
        accumulate(stateValue);
      }
    }

    proc accumulate(accumState: []) {
      for stateValue in accumState {
        accumulate(stateValue);
      }
    }

    // when combining, merge instead of
    // accumulating each individual value
    proc combine(state: borrowed minormaxk(eltType)) {
      v._data = merge(v, state.v);
    }

    proc generate() {
      return v;
    }

    proc clone() {
      return new unmanaged minormaxk(eltType=eltType, k=k, isMinK=isMinK);
    }
  }

  /*
   * Instinatiate the mink reduction class
   * so that a custom `k` value can be
   * passed into the class
   */
  proc computeMyMink(arr, kval:int) {
    var minkInstance = new unmanaged minormaxk(eltType=int, k=kval, isMinK=true);
    var result = minkInstance.identity;
    [ elm in arr with (minkInstance reduce result) ]
      result reduce= elm;
    delete minkInstance;
    return result;
  }

  proc computeMyMaxk(arr, kval:int) {
    var minkInstance = new unmanaged minormaxk(eltType=int, k=kval, isMinK=false);
    var result = minkInstance.identity;
    [ elm in arr with (minkInstance reduce result) ]
      result reduce= elm;
    delete minkInstance;
    return result;
  }
}
