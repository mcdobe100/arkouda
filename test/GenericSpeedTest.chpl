use TestBase;

use ArraySetops;

config const NINPUTS = 10_000;
config const MAX_VAL = 50_000;
config const TRIALS = 10;

proc testold(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = intersect1dold(a,b,false);
    return res;
  } else {
    var d: Diags;
    d.start();
    setxor1d(a,b,false);
    d.stop(printTime=false);
    return d.elapsed();
  }
}

proc testnew(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = intersect1d(a,b,false);
    return res;
  } else {
    var d: Diags;
    d.start();
    setxor1d(a,b,false);
    d.stop(printTime=false);
    return d.elapsed();
  }
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  var b = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);

  // run warmup test
  const oldval = testold(a,b,true);

  // run warmup test
  const newval = testnew(a,b,true);

  // check correctness
  assert(newval.equals(oldval));
  
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
  }
}
