use RadixSortLSD;
use TestBase;
use KReduce;

config const NINPUTS = 10;
config const MAX_VAL = 500;
config const k = 5;

proc testsort(a) {
  var d: Diags;

  d.start();
  var inds = radixSortLSD_ranks(a);
  var res = a[inds[0..#k]];
  d.stop(printTime=false);
  return (d.elapsed(), res);
}

proc testheap(a) {
  var d: Diags;

  d.start();
  var res = computeExtrema(a, 5);
  d.stop(printTime=false);
  return (d.elapsed(), res);
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);

  writeln(a);
  var (elapsed, res) = testsort(a);
  writeln(res);



  var (elapsedHeap, heapRes) = testheap(a);
  writeln(heapRes);

  assert(heapRes == res);

  
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("heap implementation on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsed, MB/elapsed));
  }
}