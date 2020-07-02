use TestBase;

use Indexing;

use Random;

config const ARRSIZE = 100_000_000;
config const START = 0;
config const STOP = ARRSIZE;
config const STRIDE = -1;

proc testAggregation(orig: [] int, n:int) {
  var d: Diags;
  var copy = makeDistArray((STOP-START), int);
  d.start();
  copy = sliceTest(orig, copy, START, STOP, STRIDE);
  d.stop(printTime=false);

  return d.elapsed();
}

proc testBulk(orig: [] int, n:int) {
  var d: Diags;
  var copy = makeDistArray((STOP-START), int);
  d.start();
  copy = bulkTest(orig, copy, START, STOP, STRIDE);
  d.stop(printTime=false);

  return d.elapsed();  
}

proc testCurly(orig: [] int, n:int) {
  var d: Diags;
  var copy = makeDistArray(STOP-START, int);
  d.start();
  copy = curlyTest(orig, copy, START, STOP, STRIDE);
  d.stop(printTime=false);

  return d.elapsed();  
}

proc main() {
  var orig = makeDistArray(ARRSIZE, int);
  Random.fillRandom(orig);

  const elapsed = testAggregation(orig, ARRSIZE);
  const elapsedBulk  = testBulk(orig, ARRSIZE);
  const elapsedCurly = testCurly(orig, ARRSIZE);
  const MB = byteToMB(8.0*ARRSIZE);
  if printTimes {
    writeln("Aggregated %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsed, MB/elapsed));
    writeln("Bulk copied %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsedBulk, MB/elapsedBulk));
    writeln("Curly copied %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsedCurly, MB/elapsedCurly));
  }
}
