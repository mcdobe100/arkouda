use TestBase;

use Indexing;
use Math;
use Random;

config const ARRSIZE = 1_000_000_000;
config const START = 0;
config const STOP = ARRSIZE/3;
config const STRIDE = 1;

proc testAggregation(orig: [] int, n:int, start: int, stop: int, stride: int) {
  var d: Diags;
  var copy = makeDistArray((stop-start)/abs(stride), int);
  d.start();
  copy = sliceTest(orig, copy, start, stop, stride);
  d.stop(printTime=false);

  return (d.elapsed(), copy);
}

proc testBulk(orig: [] int, n:int, start: int, stop: int, stride: int) {
  var d: Diags;
  var copy = makeDistArray((stop-start), int);
  d.start();
  copy = bulkTest(orig, copy, start, stop, stride);
  d.stop(printTime=false);

  return (d.elapsed(), copy); 
}

proc testCurly(orig: [] int, n:int, start: int, stop: int, stride: int) {
  var d: Diags;
  var copy = makeDistArray((stop-start), int);
  d.start();
  copy = curlyTest(orig, copy, start, stop, stride);
  d.stop(printTime=false);

  return (d.elapsed(), copy);
}

proc main() {
  var orig = makeDistArray(ARRSIZE, int);
  Random.fillRandom(orig);
  
  const (elapsed, aggCopy) = testAggregation(orig, ARRSIZE, START, STOP, STRIDE);
  const (elapsedBulk, bulkCopy)  = testBulk(orig, ARRSIZE, START, STOP, STRIDE);
  const (elapsedCurly, curlyCopy) = testCurly(orig, ARRSIZE, START, STOP, STRIDE);

  //correctness check
  assert(aggCopy == bulkCopy);
  assert(curlyCopy == aggCopy);
  
  const MB = byteToMB(8.0*(STOP-START));
  if printTimes {
    writeln("Aggregated %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsed, MB/elapsed));
    writeln("Bulk copied %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsedBulk, MB/elapsedBulk));
    writeln("Curly copied %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsedCurly, MB/elapsedCurly));
  }
}
