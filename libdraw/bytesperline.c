#include "u.h"
#include "lib.h"
#include "draw.h"

static
int
unitsperline(Rectangle r, int d, int bitsperunit)
{
	uint32 l, t;

	if(d <= 0 || d > 32)	/* being called wrong.  d is image depth. */
		abort();

	if(r.min.x >= 0){
		l = (r.max.x*d+bitsperunit-1)/bitsperunit;
		l -= (r.min.x*d)/bitsperunit;
	}else{			/* make positive before divide */
		t = (-r.min.x*d+bitsperunit-1)/bitsperunit;
		l = t+(r.max.x*d+bitsperunit-1)/bitsperunit;
	}
	return l;
}

int
wordsperline(Rectangle r, int d)
{
	return unitsperline(r, d, 8*sizeof(uint32));
}

int
bytesperline(Rectangle r, int d)
{
	return unitsperline(r, d, 8);
}
