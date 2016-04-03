/*
// Pickup "Keito","KANA", "KANJI" from http://www.city.kyoto.jp/kotsu/busdia/hyperdia/KEITO.htm
// stringLatinToKatakana
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFLEN 1024
#define MY_CMP( A, B ) ( strncmp( A, B, strlen(B) ) ? 0 : 1 )


int main( int argc, char *argv[] )
{
	char *p, *q, buf[BUFLEN], kanjiBuf[128];
	char *kana, *roma;
	int flg = 1;
	for( ;; )
	{
		memset( buf, 0, sizeof(buf) );
		p = fgets( &buf[0], BUFLEN -1, stdin );
		if( p == NULL ) break;
		
		if( flg )
		{
			p = strstr( p, "<P class=\"buss1\">" );
			if( p == NULL ) continue;
			p += 17;
			q = strstr( p, "çÜånìù</P>" );
			if( q == NULL ) continue;
			q[0] = 0;
			/* NSArray *a = @[ @"str1", @"str2" ]; */
			printf( "@\"%s", p );
			flg = 0;
			continue;
		}
		
		p = strstr( p,"<P class=\"buss4\">" );
		if( p == NULL ) continue;
		p += 17;
		q = strstr( p, "</P>" );
		if( q == NULL ) continue;
		*q = 0;
		kanjiBuf[0] = 0;
		strcat( &kanjiBuf[0], p );
		p = q +4;
		if( *p == 0x0A )
		{
			memset( buf, 0, sizeof(buf) );
			p = fgets( &buf[0], BUFLEN -1, stdin );
		}
		p = strstr( p, "<SMALL>" );
		if( p == NULL ) continue;
		p += 7; kana = p;
		q = strstr( p, "<BR>" );
		if( q == NULL ) continue;
		*q = 0; q += 4;
		roma = q;
		p = strstr( q, "</SMALL>" );
		if( p == NULL ) continue;
		*p = 0;
		printf( ",%s,%s/%s",kanjiBuf,kana,roma );
	}
	printf( "\",\n" );
	
	return 0;
}