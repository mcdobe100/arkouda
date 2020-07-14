use TestBase;

use ArraySetops;

config const NINPUTS = 10_000;
config const MAX_VAL = 50_000;

proc testold(a,b) {
  var d: Diags;

  d.start();
  var xor = setxor1d(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), xor);
}

proc testnew(a,b) {
  var d: Diags;

  d.start();
  var xor = setxor1dnew(a,b,false);
  d.stop(printTime=false);
  return (d.elapsed(), xor);
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  var b = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  const (elapsedOld, oldxor) = testold(a,b);
  const (elapsedNew, newxor) = testnew(a,b);

  assert(oldxor.equals(newxor));
  
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("old xor on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedOld, MB/elapsedOld));
    writeln("new xor on %i elements (%.1dr MB) in %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedNew, MB/elapsedNew));
  }
}
