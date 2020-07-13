/* Array set operations
 includes intersection, union, xor, and diff

 currently, only performs operations with integer arrays 
 */

module ArraySetopsTemp
{
    use ServerConfig;

    use SymArrayDmap;

    use RadixSortLSD;
    use Unique;
    use Indexing;
    use In1d;
    use Memory;


    /*
    Small bound const. Brute force in1d implementation recommended.
    */
    private config const sBound = 2**4; 

    /*
    Medium bound const. Per locale associative domain in1d implementation recommended.
    */
    private config const mBound = 2**25; 

    proc intersect1dold(a: [] int, b: [] int, assume_unique: bool) {
      //if not unique, unique sort arrays then perform operation
      if (!assume_unique) {
        var a1  = uniqueSort(a, false);
        var b1  = uniqueSort(b, false);
        return intersect1dHelperold(a1, b1);
      }
      return intersect1dHelperold(a,b);
    }

    // Get intersect of 2 arrays
    // first concatenates the 2 arrays, then
    // sorts arrays and removes all values that
    // only occur once
    proc intersect1dHelperold(a: [] ?t, b: [] t) {
      var aux = radixSortLSD_keys(concatset(a,b));

      var mask: [aux.domain] bool;
      var maskIndices = aux.domain#(aux.size-1);

      forall i in maskIndices {
        mask[i] = aux[i] == aux[i+1];
      }
      
      const int1d = boolIndexer(aux[aux.domain#(aux.size-1)], mask);
      return int1d;
    }
    
    // returns the exclusive-or of 2 arrays
    proc setxor1dold(a: [] int, b: [] int, assume_unique: bool) {
      //if not unique, unique sort arrays then perform operation
      if (!assume_unique) {
        var a1  = uniqueSort(a, false);
        var b1  = uniqueSort(b, false);
        return  setxor1dHelperold(a1, b1);
      }
      return setxor1dHelperold(a,b);
    }

    // Gets xor of 2 arrays
    // first concatenates the 2 arrays, then
    // sorts and removes all values that occur
    // more than once
    proc setxor1dHelperold(a: [] ?t, b: [] t) {
      var aux = radixSortLSD_keys(concatset(a,b));

      var sliceComp = sliceTail(aux) != sliceHead(aux);
      
      // Concatenate a `true` onto each end of the array
      var flag = makeDistArray((sliceComp.size + 2), bool);
      
      flag[0] = true;
      flag[{1..#(sliceComp.size)}] = sliceComp;
      flag[sliceComp.size + 1] = true;

      var mask = sliceTail(flag) & sliceHead(flag);

      var ret = boolIndexer(aux, mask);
      writeln("Old memory usage setxor1d: ", Memory.memoryUsed());
      return ret;
    }

    // returns the set difference of 2 arrays
    proc setdiff1dold(a: [] int, b: [] int, assume_unique: bool) {
      //if not unique, unique sort arrays then perform operation
      if (!assume_unique) {
        var a1  = uniqueSort(a, false);
        var b1  = uniqueSort(b, false);
        return setdiff1dHelperold(a1, b1);
      }
      return setdiff1dHelperold(a,b);
    }
    
    // Gets diff of 2 arrays
    // first checks membership of values in
    // fist array in second array and stores
    // as a boolean array and inverts these
    // values and returns the array indexed
    // with this inverted array
    proc setdiff1dHelperold(a: [] ?t, b: [] t) {
        var truth = makeDistArray(a.size, bool);

        // based on size of array, determine which method to use 
        if (b.size <= sBound) then truth = in1dGlobalAr2Bcast(a, b);
        else if (b.size <= mBound) then truth = in1dAr2PerLocAssoc(a, b);
        else truth = in1dSort(a,b);
        
        truth = !truth;

        var ret = boolIndexer(a, truth);

        return ret;
    }
    
    // Gets union of 2 arrays
    // first concatenates the 2 arrays, then
    // sorts resulting array and ensures that
    // values are unique
    proc union1dold(a: [] int, b: [] int) {
      var a1  = uniqueSort(a, false);
      var b1  = uniqueSort(b, false);

      var aux = concatset(a1, b1);

      var ret = uniqueSort(aux, false);
      return ret;
    }
}