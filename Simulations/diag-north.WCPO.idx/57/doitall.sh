#!/bin/sh
#  ---------
#   PHASE 9
#  ---------
 mfclo64 alb.frq 08.par 09.par -switch 2 1 1 500 2 116 20
 mfclo64 alb.frq 09.par 09.par -switch 3 1 50 -6 1 1 5000 2 116 300
#

mfclo64 alb.frq 09.par hessian -switch 1 1 145 1
mfclo64 alb.frq 09.par hessian -switch 1 1 145 5
mfclo64 alb.frq 09.par hessian -switch 2 1 37 1 1 145 2
mfclo64 alb.frq 09.par hessian -switch 1 1 145 4
