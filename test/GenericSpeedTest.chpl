use TestBase;

use ArraySetops;

config const NINPUTS = 10_000;
config const MAX_VAL = 50_000;
config const TRIALS = 10;

proc testold(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = setxor1d(a,b,false);
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
    var res = setxor1d(a,b,false);
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

  // run warmup tests
  const oldval = testold(a,b,true);
  const newval = testnew(a,b,true);

  // check correctness
  assert(oldval.equals(newval));

  var oldSum = 0.0;
  forall i in 0..#TRIALS with (+ reduce oldSum) {
    oldSum += testold(a,b);
  }
  const elapsedOldavg = oldSum/TRIALS;

  var newSum = 0.0;
  forall i in 0..#TRIALS with (+ reduce newSum) {
    newSum += testnew(a,b);
  }
  const elapsedNewavg = newSum/TRIALS;

  
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("Current main implementation with %i elements (%.1dr MB) took %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedOldavg, MB/elapsedOldavg));
    writeln("Implementation with changes with %i elements (%.1dr MB) took %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedNewavg, MB/elapsedNewavg));
  }
}
