/* http://groups.google.com/group/comp.os.plan9/msg/f409ccd4c372f549 */
#include <u.h>
#include <lib.h>
#include <draw.h>
#include <cursor.h>

Image *col;
Image *back;

ulong types[] = {
		RGBA32, 
		ARGB32, 
		XRGB32,
		XBGR32,
		RGB24,
};
char *descs[] = {
	"rgba32",
	"argb32",
	"xrgb32",
	"xbgr32",
	"rgb24",
};

void
main(void) {
	int fd, i, j, k;
	char *str;
	ulong type = RGBA32;
	Display *display = NULL;

	if(initdraw(nil, nil, "tri") < 0)
		exits("initdraw");

	for(j = 0; j < 5; j++) {
		for(k = 0; k < 5; k++) {
			str= smprint("/tmp/%s-over-%s.1", descs[k], descs[j]);
			print("creating: %s\n", str);
			back = allocimage(display, Rect(0, 0, 800, 300), types[j], 0, DBlack);

			for(i = 0; i < 0xff; i++) {
				col = allocimage(display, Rect(0,0,1,1), types[k], 1, setalpha(DWhite, 0xff-i));
				draw(back, Rect(0,i,200,i+1), col, nil, ZP);
				freeimage(col);
				col = allocimage(display, Rect(0,0,1,1), types[k], 1, setalpha(DRed, 0xff-i));
				draw(back, Rect(200,i,400,i+1), col, nil, ZP);
				freeimage(col);
				col = allocimage(display, Rect(0,0,1,1), types[k], 1, setalpha(DGreen, 0xff-i));
				draw(back, Rect(400,i,600,i+1), col, nil, ZP);
				freeimage(col);
				col = allocimage(display, Rect(0,0,1,1), types[k], 1, setalpha(DBlue, 0xff-i));
				draw(back, Rect(600,i,800,i+1), col, nil, ZP);
				freeimage(col);

			}

			fd = create(str, OWRITE, 0664);
			if(fd < 0)
				sysfatal("create");
			writeimage(fd, back, 0);
			close(fd);
		}
	}
}
