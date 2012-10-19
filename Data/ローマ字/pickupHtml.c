/*
// Pickup "htm" from http://www.city.kyoto.jp/kotsu/busdia/hyperdia/KANA.htm
// pickupHtml
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFLEN 1024
#define MY_CMP( A, B ) ( strncmp( A, B, strlen(B) ) ? 0 : 1 )


int main( int argc, char *argv[] )
{
	char *p, *html, buf[BUFLEN];
	int i = 0;
	for( ;; )
	{
		memset( buf, 0, sizeof(buf) );
		p = fgets( &buf[0], BUFLEN -1, stdin );
		if( p == NULL ) break;
		
		p = strstr( p, "A href=\"" );
		if( p == NULL ) continue;
		p += 8;
		html = p; p[11] = 0;
		printf( "curl -o %s http://www.city.kyoto.jp/kotsu/busdia/hyperdia/%s\n",html, html );
	}
	return 0;
}