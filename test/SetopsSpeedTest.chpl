use TestBase;

use ArraySetops;
use ArraySetopsTemp;

config const NINPUTS = 10_000;
config const MAX_VAL = 50_000;

proc testIntersect1d(a,b,n:int) {
  var d: Diags;

  d.start();
  var in1d = intersect1d(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), in1d);
}

proc testIntersect1dold(a,b,n:int) {
  var d: Diags;

  d.start();
  var in1d = intersect1dold(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), in1d);
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
  var a = makeDistArray(NINPUTS, int);
  var b = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);
  
  const (elapsedIntersect, in1dNew) = testIntersect1d(a,b,NINPUTS);
  const (elapsedIntersectold, in1dOld) = testIntersect1dold(a,b,NINPUTS);
  const elapsedDiff = testSetDiff1d(NINPUTS);
  const elapsedDiffold = testSetDiff1dold(NINPUTS);
  const elapsedXor = testSetXor1d(NINPUTS);
  const elapsedXorold = testSetXor1dold(NINPUTS);
  const elapsedUnion = testUnion1d(NINPUTS);
  const elapsedUnionold = testUnion1dold(NINPUTS);

  assert(in1dNew.equals(in1dOld));
  //writeln("INTERSECT New: ",in1dNew);
  //writeln("INTERSECT Old: ",in1dOld);
  //writeln("intersect1d matched with: ", in1dNew == in1dOld);

  if(in1dNew.equals(in1dOld)) then
    writeln("worked");
    
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