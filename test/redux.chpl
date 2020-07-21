use MinKReduction;
use Heap;
use Math;
use TestBase;
/*
var h = new heap(int, 5);

h.pushIfSmaller(5);
h.pushIfSmaller(3);
h.pushIfSmaller(4);
h.pushIfSmaller(6);
h.pushIfSmaller(1);
h.pushIfSmaller(0);

var a = [7,2,4,1,2,8,93,3];

writeln("new: ",computeMyMink(a, 4));
writeln("regular: ", regcomputeMyMink(a,4));
writeln(computeMyMink(h, 2));

writeln(h._data);
*/

config const NINPUTS = 100_000_000;
config const MAX_VAL = 50_000;
config const K = 1_000_000;

proc testheap(a) {
  var d: Diags;

  d.start();
  computeMyMink(a,K);
  d.stop(printTime=false);
  return d.elapsed();
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);

  var h = new heap(int, NINPUTS);
  
  const elapsed = testheap(h);

  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("heap implementation on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsed, MB/elapsed));
  }
}