use TestBase;

use ArraySetops;
use ArraySetopsTemp;

config const NINPUTS = 1_000_000;
config const MAX_VAL = 5_000_000;

proc testIntersect1d(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  intersect1d(a,b,false);
  d.stop(printTime=false);
  return d.elapsed();
}

proc testIntersect1dold(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  intersect1dold(a,b,false);
  d.stop(printTime=false);
  return d.elapsed();
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
  return d.elapsed();
}

proc testSetDiff1dold(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  setdiff1dold(a,b,false);
  d.stop(printTime=false);
  return d.elapsed();
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
  return d.elapsed();
}

proc testSetXor1dold(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  setxor1dold(a,b,false);
  d.stop(printTime=false);
  return d.elapsed();
}

proc testUnion1d(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  union1d(a,b);
  d.stop(printTime=false);
  return d.elapsed();
}

proc testUnion1dold(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  union1dold(a,b);
  d.stop(printTime=false);
  return d.elapsed();
}

proc main() {
  const elapsedIntersect = testIntersect1d(NINPUTS);
  const elapsedIntersectold = testIntersect1dold(NINPUTS);
  const elapsedDiff = testSetDiff1d(NINPUTS);
  const elapsedDiffold = testSetDiff1dold(NINPUTS);
  const elapsedXor = testSetXor1d(NINPUTS);
  const elapsedXorold = testSetXor1dold(NINPUTS);
  const elapsedUnion = testUnion1d(NINPUTS);
  const elapsedUnionold = testUnion1dold(NINPUTS);

  const MB:real = byteToMB(NINPUTS*8);
  if printTimes {
    writeln("intersect1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedIntersect, MB/elapsedIntersect));
    writeln("Old intersect1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsedIntersectold, MB/elapsedIntersectold));
    writeln("setdiff1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedDiff, MB/elapsedDiff));
    writeln("Old setdiff1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsedDiffold, MB/elapsedDiffold));
    writeln("setxor1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedXor, MB/elapsedXor));
    writeln("Old setxor1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)\n".format(NINPUTS, MB, elapsedXorold, MB/elapsedXorold));
    writeln("union1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedUnion, MB/elapsedUnion));
    writeln("Old union1d on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedUnionold, MB/elapsedUnionold));
  }
}