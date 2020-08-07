use RadixSortLSD;
use TestBase;
use KReduce;

config const NINPUTS = 10_000_000;
config const MAX_VAL = max(int);
config const k = 1_000_000;;

proc testsort(a) {
  var d: Diags;

  d.start();
  var inds = radixSortLSD_ranks(a);
  var res = inds[0..#k];
  d.stop(printTime=false);
  return (d.elapsed(), res);
}

proc testheap(a) {
  var d: Diags;

  d.start();
  var res = computeInds(a, k);
  d.stop(printTime=false);
  return (d.elapsed(), res);
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);

  var (elapsed, res) = testsort(a);



  var (elapsedHeap, heapRes) = testheap(a);

  assert(heapRes == res);

  
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("heap implementation on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedHeap, MB/elapsed));
  }
}