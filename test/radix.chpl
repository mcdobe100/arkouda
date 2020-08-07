use RadixSortLSD;
use TestBase;
use KReduce;

config const NINPUTS = 100_000;
config const MAX_VAL = max(int);
config const kval = 1_000;;

proc testsort(a, k) {
  var d: Diags;

  d.start();
  var inds = radixSortLSD_ranks(a);
  var res = inds[0..#k];
  d.stop(printTime=false);
  return (d.elapsed(), res);
}

proc testheap(a,k) {
  var d: Diags;

  d.start();
  var res = computeInds(a, k);
  d.stop(printTime=false);
  return (d.elapsed(), res);
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);

  for i in 1..10 {
    for j in 1..5 {
      var a = makeDistArray(NINPUTS*i*10, int);
      fillInt(a, 0, MAX_VAL);
      var (elapsed, res) = testsort(a, j*10*kval);
      var (elapsedHeap, heapRes) = testheap(a, j*10*kval);
      assert(heapRes == res);
      if(elapsed < elapsedHeap) {
        writeln("Heap slower for k=",j*10*kval," and size=",i*10*NINPUTS);
      } else {
        writeln("heap faster...");
      }
    }
  }

  
  /*  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
  writeln("heap implementation on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedHeap, MB/elapsed));
  }*/
}