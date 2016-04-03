/*
// Pickup "htm","KANA", "KANJI" from http://www.city.kyoto.jp/kotsu/busdia/hyperdia/KANA.htm
// stringLatinToKatakana
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFLEN 1024
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
			"�l���͌���","���s�w�O","�O������O","���s�w�������A�o���e�B�O","�k��H�o�X�^�[�~�i��",
			"�l���G��","�l���{","�_��","�l������O","�k�씒�~��",
			"����H�l��","���t���O","��t���O","��{���o��","�͌������o��",
			"�͌����O��","���s�s�����O","����w�O","���m���~��","���`�V�_��w�O",
			"�l���{�i��s�k�l�j", "���t���O", "��t����", NULL
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

int main( int argc, char *argv[] )
{
	char *p, buf[BUFLEN];
	char *nothing = "nothing";
	char *html, *kana, *kanji, *note;
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
		p += 13;
		kana = p;
		p = strstr( p, "</A></TD><TD><A href=" );
		if( p == NULL ) continue;
		p[0] = 0; /* </A></TD><TD><A href=\"menu481.htm\"> */
		p += 35;
		kanji = p;
		p = strstr( p, "</A>" );
		if( p == NULL ) continue;
		p[0] = 0;
		/* NSArray *a = @[ @"str1", @"str2" ]; */
		i = checkNote( kanji );
		if( 0 <= i )
			note = busStopImage[i];
		else
			note = nothing;
		printf( "@\"%s,%s,%s,%s\",\n",html,kana,kanji,note );
	}
	return 0;
}