use TestBase;

use ArraySetops;

config const NINPUTS = 100_000_000;
config const MAX_VAL = 5000;

enum testMode {fixed, variable};
config const mode = testMode.variable;

proc testIntersect1d(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);
  
  d.start();
  intersect1d(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), a.size*8);
}

proc testSetDiff1d(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);  

  d.start();
  setdiff1d(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), a.size*8);
}

proc testSetXor1d(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  setxor1d(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), a.size*8);
}

proc testUnion1d(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  union1d(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), a.size*8);
}


proc main() {
  const (elapsed, nbytes) = testIntersect1d(NINPUTS);
  const (elapsedDiff, _) = testSetDiff1d(NINPUTS);
  const (elapsedXor, _) = testSetXor1d(NINPUTS);
  const (elapsedUnion, _) = testUnion1d(NINPUTS);
  
  const MB:real = byteToMB(nbytes:real);
  //if printTimes then
    writeln("intersect1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsed, MB/elapsed));
    writeln("setdiff1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsedDiff, MB/elapseDiff));
    writeln("setxor1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsedXor, MB/elapsedXor));
    writeln("union1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsedUnion, MB/elapsedUnion));
}
