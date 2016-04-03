/*
// Pickup "FAC".htm from http://www.city.kyoto.jp/kotsu/busdia/hyperdia/mnufac[1-10].htm >> mnuFac.htm
// grep TD mnuFac.htm > td.list
// <me> < td.list > output.log
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MY_CMP( A, B ) ( strncmp( A, B, strlen(B) ) ? 0 : 1 )

static char *busStopImage[] = {
		"shijo_kawaramachi.gif", "kyoto_sta.gif","sanjo_keihan.gif","avanti.gif","kitaoji_bt.gif",
		"shijo_karasuma.gif","shijo_omiya.gif","gion.gif","shijo_keihan.gif","kitano_hakubaicho.gif",
		"nishioji_shijo.gif","kinkaku.gif","ginkaku.gif","senbon_imadegawa.gif","kawaramachi_imadegawa.gif",
		"kawaramachi_sanjo.gif","kyoto_siyakusyo.gif","nijo_sta.gif","nishinokyo_enmachi.gif",
		"uzumasa.png",
		"shijo_omiya.gif","kinkaku.gif","ginkaku.gif"
	};

int checkNote( char *str )
{
	int i, ret = -1;
	static char *busStopHasNote[] = {
			"四条河原町","京都駅前","三条京阪前","京都駅八条口アバンティ前","北大路バスターミナル",
			"四条烏丸","四条大宮","祇園","四条京阪前","北野白梅町",
			"西大路四条","金閣寺前","銀閣寺前","千本今出川","河原町今出川",
			"河原町三条","京都市役所前","二条駅前","西ノ京円町","太秦天神川駅前",
			"四条大宮（南行北詰）", "金閣寺前", "銀閣寺道", NULL
		};
	for( i = 0; busStopHasNote[i] != NULL ; i++ )
	{
		if( MY_CMP( busStopHasNote[i], str ) )
		{
			ret = i;
			break;
		}
	}
	
	return ret;
}


#define BUFLEN 1024
int main( int argc, char *argv[] )
{
	char *p, *q, buf[BUFLEN];
	char *fac, *html, *note;
	char *nothing = "nothing";
	int i = 0;
	for( ;; )
	{
		memset( buf, 0, sizeof(buf) );
		p = fgets( &buf[0], BUFLEN -1, stdin );
		if( p == NULL ) break;
		
		p = strstr( p, "<TR><TD>" );
		if( p == NULL ) continue;
		p += 8;
		if( p[1] == 'H' ) continue;
		q = strstr( p, "</TD><TD><A href=\"" );
		q[0] = 0; q += 18; html = q;
		fac = p;
		p = strstr( q, "htm\">" );
		p += 3; p[0] = 0; p += 2;
		q = strstr( p, "</A>" );
		q[0] = 0;
		if( strcmp( fac, p ) == 0 ) continue;
		
		i = checkNote( p );
		if( 0 <= i )
			note = busStopImage[i];
		else
			note = nothing;

		
		printf( "@\"%s,%s,%s,%s\",\n",html,fac,p,note );
	}
	return 0;
}