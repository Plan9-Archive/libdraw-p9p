#!/bin/sh

# Most of the library files come in virtually unchanged.
# Rather than maintain the few changes by hand, we keep a set
# of ed scripts that we can run on the originals to produce 
# the versions we need.
#
# Note that the headers are in ./

fatal() {
	echo $* >&2
	exit 1
}

case "$#" in
1)
	outdir=$1
	;;
*)
	fatal "usage: $0 dir"
esac

autofiles=`cat $1/autogen.files` || fatal "$0: could not read $outdir/autogen.files"

for f in $autofiles
do
	ed=`echo $f | sed 's;.*/;;; s;\.[ch]$;;; s;$;.ed;'`
	out=`echo $f | sed 's;.*/;'$outdir'/;'`
	echo $f '->' $out
	test -f $out && chmod +w $out
	(
		echo ',s;"../port/;";g'
		echo ',s;#include.*<;#include ";g'
		echo ',s;#include.*>;&FIXINCLUDEME;g'
		echo ',s;>FIXINCLUDEME;";g'
		echo ',s;"libc.h";"lib.h";g'
		echo 'g/#pragma/d'
		echo 'g/#include "pool/d'
		test -f $ed && cat $ed
		echo w $out
		echo q
	) | ed $plan9$f 2>&1 | egrep -v '^[0-9?]+$'
	chmod -w $out
done
