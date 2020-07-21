/* Array set operations
 includes intersection, union, xor, and diff

 currently, only performs operations with integer arrays 
 */

module MinKMsg
{
    use ServerConfig;

    use Time only;
    use Math only;
    use Reflection only;

    use MultiTypeSymbolTable;
    use MultiTypeSymEntry;
    use SegmentedArray;
    use ServerErrorStrings;

    use MinKReduction;
    use Indexing;
    use RadixSortLSD;
    
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
        var (name, k) = payload.decode().splitMsgToTuple(2);
        
        var vname = st.nextName();

        var gEnt: borrowed GenSymEntry = st.lookup(name);
        
        select(gEnt.dtype) {
          when (DType.Int64) {
             var e = toSymEntry(gEnt,int);
             
             var aV = computeMyMink(e.a, k:int);
             st.addEntry(vname, new shared SymEntry(aV));

             var s = try! "created " + st.attrib(vname);
             return s;
           }
           otherwise {
             return notImplementedError("mink",gEnt.dtype);
           }
        }
    }
}
