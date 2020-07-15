use TestBase;

use Indexing;

config const NINPUTS = 1_000_000_000;
config const MAX_VAL = 50_000;
config const TRIALS = 10;

proc testold(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = concatset(a,b);
    return res;
  } else {
    var d: Diags;
    d.start();
    concatset(a,b);
    d.stop(printTime=false);
    return d.elapsed();
  }
}

proc testnew(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = concatsetnew(a,b);
    return res;
  } else {
    var d: Diags;
    d.start();
    concatsetnew(a,b);
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

  var oldSum = 0.0;
  for i in 0..#TRIALS {
    oldSum += testold(a,b);
  }
  const elapsedOldavg = oldSum/TRIALS;

  // run warmup test
  const newval = testnew(a,b,true);
  
  var newSum = 0.0;
  for i in 0..#TRIALS {
    newSum += testnew(a,b);
  }
  const elapsedNewavg = newSum/TRIALS;

  // check correctness
  assert(newval.equals(oldval));
  
  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("Current main implementation with %i elements (%.1dr MB) took %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedOldavg, MB/elapsedOldavg));
    writeln("Implementation with changes with %i elements (%.1dr MB) took %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedNewavg, MB/elapsedNewavg));
  }
}
