/* min-k reduction 
 * Stores the sorted minimum k values onto the server
 */

module KExtremeMsg
{
    use ServerConfig;

    use Time only;
    use Math only;
    use Reflection only;

    use MultiTypeSymbolTable;
    use MultiTypeSymEntry;
    use SegmentedArray;
    use ServerErrorStrings;

    use KReduce;
    use Indexing;
    use RadixSortLSD;
    use ArraySetopsMsg;

    /*
    Parse, execute, and respond to a intersect1d message
    :arg reqMsg: request containing (cmd,name,name2,assume_unique)
    :type reqMsg: string
    :arg st: SymTab to act on
    :type st: borrowed SymTab
    :returns: (string) response message
    */
    proc minkMsg(cmd: string, payload: bytes, st: borrowed SymTab): string throws {
        param pn = Reflection.getRoutineName();
        var repMsg: string; // response message
        // split request into fields
        var (name, k, returnIndices) = payload.decode().splitMsgToTuple(3);

        var vname = st.nextName();

        var gEnt: borrowed GenSymEntry = st.lookup(name);

        select(gEnt.dtype) {
          when (DType.Int64) {
             var e = toSymEntry(gEnt,int);

             var aV;

             if !stringtobool(returnIndices) {
               aV = computeExtrema(e.a, k:int);
             } else {
               aV = computeInds(e.a, k:int);
             }

             st.addEntry(vname, new shared SymEntry(aV));

             var s = try! "created " + st.attrib(vname);
             return s;
          }
          when (DType.Float64) {
            if !stringtobool(returnIndices) {
             var e = toSymEntry(gEnt,real);

             var aV = computeExtrema(e.a, k:int);

             st.addEntry(vname, new shared SymEntry(aV));

             var s = try! "created " + st.attrib(vname);
             return s;
            } else {
             var e = toSymEntry(gEnt,real);
             var aV;
             if k:int > 1_000_000 then
               aV = computeInds(e.a, k:int);
             else
               aV = computeIndsSort(e.a, k:int);

             st.addEntry(vname, new shared SymEntry(aV));

             var s = try! "created " + st.attrib(vname);
             return s;
            }
           }
           otherwise {
             return notImplementedError("mink",gEnt.dtype);
           }
        }
    }

    proc maxkMsg(cmd: string, payload: bytes, st: borrowed SymTab): string throws {
        param pn = Reflection.getRoutineName();
        var repMsg: string; // response message
        // split request into fields
        var (name, k, returnIndices) = payload.decode().splitMsgToTuple(3);

        var vname = st.nextName();

        var gEnt: borrowed GenSymEntry = st.lookup(name);

        select(gEnt.dtype) {
          when (DType.Int64) {
             var e = toSymEntry(gEnt,int);

             var aV;
             if !stringtobool(returnIndices) {
               aV = computeExtrema(e.a, k:int, false);
             } else {
               aV = computeInds(e.a, k:int, false);
             }

             st.addEntry(vname, new shared SymEntry(aV));

             var s = try! "created " + st.attrib(vname);
             return s;
           }
           when (DType.Float64) {
             if !stringtobool(returnIndices) {
               var e = toSymEntry(gEnt,real);

               var aV = computeExtrema(e.a, k:int, false);

               st.addEntry(vname, new shared SymEntry(aV));

               var s = try! "created " + st.attrib(vname);
               return s;
             } else {
               var e = toSymEntry(gEnt,real);

               var aV = computeInds(e.a, k:int, false);

               st.addEntry(vname, new shared SymEntry(aV));

               var s = try! "created " + st.attrib(vname);
               return s;
               
             }
           }

           otherwise {
             return notImplementedError("maxk",gEnt.dtype);
           }
        }
    }

}
