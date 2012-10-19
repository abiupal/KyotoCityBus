/*
// Pickup "Keito".htm from http://www.city.kyoto.jp/kotsu/busdia/keitou/keitou.htm
// <me> < keitou.html > output.html
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFLEN 1024
int main( int argc, char *argv[] )
{
	char *p, *q, buf[BUFLEN];
	int i = 0;
	for( ;; )
	{
		memset( buf, 0, sizeof(buf) );
		p = fgets( &buf[0], BUFLEN -1, stdin );
		if( p == NULL ) break;
		
		for( ;; )
		{
			p = strstr( p, "A href = \"./kto/" );
			if( p == NULL ) break;
			p += 16;
			q = strstr( p, "htm" );
			q[3] = 0;
			printf( "curl -o %s http://www.city.kyoto.jp/kotsu/busdia/keitou/kto/%s\n",p, p );
		}
	}
	return 0;
}