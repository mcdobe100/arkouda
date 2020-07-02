use TestBase;

use Indexing;

use Random;

config const ARRSIZE = 100_000_000;
config const START = 0;
config const STOP = ARRSIZE/2;

proc testAggregation(n:int, size=8) {
  var d: Diags;
  var orig = makeDistArray(n, int);
  Random.fillRandom(orig);
  var copy = makeDistArray(STOP-START, int);
  d.start();
  copy = sliceTest(orig, copy, START, STOP);
  d.stop(printTime=false);

  return (d.elapsed(), n*size);
}

proc testBulk(n:int, size=8) {
  var d: Diags;
  var orig = makeDistArray(n, int);
  Random.fillRandom(orig);
  var copy = makeDistArray(STOP-START, int);
  d.start();
  copy = bulkTest(orig, copy, START, STOP);
  d.stop(printTime=false);

  return (d.elapsed(), n*size);  
}

proc testCurly(n:int, size=8) {
  var d: Diags;
  var orig = makeDistArray(n, int);
  Random.fillRandom(orig);
  var copy = makeDistArray(STOP-START, int);
  d.start();
  copy = curlyTest(orig, copy, START, STOP);
  d.stop(printTime=false);

  return (d.elapsed(), n*size);  
}

proc main() {
  const (elapsed, nbytes) = testAggregation(ARRSIZE);
  const (elapsedBulk, _) = testBulk(ARRSIZE);
  const (elapsedCurly, _) = testCurly(ARRSIZE);
  const MB = byteToMB(nbytes);
  if printTimes {
    writeln("Aggregated %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsed, MB/elapsed));
    writeln("Bulk copied %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsedBulk, MB/elapsedBulk));
    writeln("Curly copied %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(ARRSIZE, MB, elapsedCurly, MB/elapsedCurly));
  }
}
