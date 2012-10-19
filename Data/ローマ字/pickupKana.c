/*
// Pickup "KANA".htm from http://www.city.kyoto.jp/kotsu/busdia/hyperdia/mnukana.htm
// a.htm - wa.htm
// <me> < mnuKana.html > output.html
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFLEN 1024
int main( int argc, char *argv[] )
{
	char *p, buf[BUFLEN];
	int i = 0;
	for( ;; )
	{
		memset( buf, 0, sizeof(buf) );
		p = fgets( &buf[0], BUFLEN -1, stdin );
		if( p == NULL ) break;
		
		for( ;; )
		{
			p = strstr( p, "A href=\"" );
			if( p == NULL ) break;
			p += 8;
			if( p[1] == '.' ) p[5] = 0;
			else p[6] = 0;
			printf( "curl -o %s http://www.city.kyoto.jp/kotsu/busdia/hyperdia/%s\n",p, p );
			p[5] = 0x30;
			p[6] = 0x30;
		}
	}
	return 0;
}