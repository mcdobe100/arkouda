from arkouda.client import generic_msg, verbose
from arkouda.pdarrayclass import pdarray, create_pdarray
from arkouda.pdarraycreation import zeros, array
from arkouda.strings import Strings

global verbose

__all__ = ["mink"]
global verbose

def mink(pda, k):
    if isinstance(pda, pdarray):
        repMsg = generic_msg("mink {} {}".format(pda.name, k))
        return create_pdarray(repMsg)
    else:
        raise TypeError("must be pdarray {}".format(pda))