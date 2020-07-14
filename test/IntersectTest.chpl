use TestBase;

use ArraySetops;

config const NINPUTS = 10_000;
config const MAX_VAL = 50_000;

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
  intersect1dperloc(a,b,false);
  d.stop(printTime=false);
  return d.elapsed();
}

proc testIntersect1doneline(n:int) {
  var d: Diags;
  var a = makeDistArray(n, int);
  var b = makeDistArray(n, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  d.start();
  intersect1doneline(a,b,false);
  d.stop(printTime=false);
  return d.elapsed();
}

proc main() {
  const elapsedIntersect = testIntersect1d(NINPUTS);
  const elapsedIntersect1 = testIntersect1dold(NINPUTS);
  const elapsedIntersect2 = testIntersect1doneline(NINPUTS);

  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("intersect per loc on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedIntersect, MB/elapsedIntersect));
    writeln("intersect one line on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedIntersect2, MB/elapsedIntersect2));
  }
}