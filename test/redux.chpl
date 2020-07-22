use MinKReduction;
use Heap;
use Math;
use TestBase;

config const NINPUTS = 100;
config const MAX_VAL = 50_000;
config const K = 10;
config const REG = false;

proc testheap(a) {
  var d: Diags;

  d.start();
  computeMyMink(a,K);
  d.stop(printTime=false);
  return d.elapsed();
}

proc testreg(a) {
  var d: Diags;

  d.start();
  regcomputeMyMink(a,K);
  d.stop(printTime=false);
  return d.elapsed();
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);

  var elapsed;
  if(REG) {
    elapsed = testheap(a);
  } else {
    elapsed = testreg(a);
  }

  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("heap implementation on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsed, MB/elapsed));
  }
}