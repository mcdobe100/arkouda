use TestBase;

use ArraySetops;


config const ARRSIZE = 10_000_000;
config const GROUPS = 64;
config const NINPUTS = 10_000;
config const MAX_VAL = 50_000;
config const TRIALS = 10;

proc testold(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = segMean(a,b,false);
    return res;
  } else {
    var d: Diags;
    d.start();
    segMean(a,b,false);
    d.stop(printTime=false);
    return d.elapsed();
  }
}

proc testnew(a, b, param warmUp=false) {
  //If warm up task then return value to check correctness
  if(warmUp) {
    var res = segMean(a,b,true);
    return res;
  } else {
    var d: Diags;
    d.start();
    segMean(a,b,true);
    d.stop(printTime=false);
    return d.elapsed();
  }
}

proc main() {
  var a = makeDistArray(NINPUTS, int);
  var b = makeDistArray(NINPUTS, int);
  fillInt(a, 0, MAX_VAL);
  fillInt(b, 0, MAX_VAL);
    var orig = makeDistArray(ARRSIZE, real);
  fillReal(orig, 0.0, 500000.0);
  var segments = makeDistArray(GROUPS, int);
  fillInt(segments, 1, GROUPS+1);

  // run warmup test
  const newval = testnew(orig,segments,true);

  var newSum = 0.0;
  for i in 0..#TRIALS {
    var time = testnew(orig,segments);
    writeln(time);
    newSum += time;
  }
  const elapsedNewavg = newSum/TRIALS;

  // run warmup test
  const oldval = testold(orig,segments,true);

  var oldSum = 0.0;
  for i in 0..#TRIALS {
    var time = testold(orig,segments);
    writeln(time);
    oldSum += time;
  }
  const elapsedOldavg = oldSum/TRIALS;


  // check correctness
  assert(newval.equals(oldval));

  const MB:real = byteToMB(NINPUTS*8.0);
  if printTimes {
    writeln("Current main implementation with %i elements (%.1dr MB) took %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedOldavg, MB/elapsedOldavg));
    writeln("Implementation with changes with %i elements (%.1dr MB) took %.2dr seconds (%.2dr MB/s)".format(NINPUTS, MB, elapsedNewavg, MB/elapsedNewavg));
  }
}
