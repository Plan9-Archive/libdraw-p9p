#!/bin/sh

# Most of the library files come in virtually unchanged.
# Rather than maintain the few changes by hand, we keep a set
# of ed scripts that we can run on the originals to produce 
# the versions we need.
#
# Note that the headers are in ./ and include/

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

test -d "$plan9" ||
	fatal "$0: \$plan9=\"$plan9\" is not a directory"

autofiles=`cat $1/autogen.files 2>/dev/null` ||
	fatal "$0: could not read $outdir/autogen.files"

for f in $autofiles
do
	out=`echo $f | sed 's;.*/;'$outdir'/;'`
	ed=`echo $out | sed 's;\.[ch]$;.ed;'`
	patch=`echo $ed | sed 's;\.ed$;.patch;'`
	echo $f '->' $out >&2
	test -f $out && chmod +w $out
	(
		test -f "$patch" && cat $patch
		echo ',s;"../port/;";g'
		echo ',s;#include.*<;#include ";g'
		echo ',s;#include.*>;&FIXINCLUDEME;g'
		echo ',s;>FIXINCLUDEME;";g'
		echo ',s;"libc.h";"lib.h";g'
		echo 'g/#pragma/d'
		echo '/#include "pool\.h"/d'
		test -f $ed && cat $ed
		echo w $out
		echo q
	) | ed $plan9$f 2>&1 | egrep -v '^[0-9?]+$'
	chmod -w $out
done
