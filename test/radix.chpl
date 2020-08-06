use RadixSortLSD;
use TestBase;
use KReduce;

config const NINPUTS = 1_000;
config const MAX_VAL = 500;
config const k = 10;

proc testsort(a) {
  var d: Diags;

  d.start();
  var res = radixSortLSD_ranks(a);
  res = a[res];
  d.stop(printTime=false);
  return d.elapsed();
}

proc testtuple(a) {
  var d: Diags;

  d.start();
  var res = computeExtrema(a,k,false,false);
  d.stop(printTime=false);
  return d.elapsed();
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);

  var elapsed;
  elapsed = testtuple(a);
 
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("heap implementation on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsed, MB/elapsed));
  }
}