//
//  NSString+NSString_Henkan.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/08/08.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Henkan)

// 半角→全角
- (NSString*) stringToFullwidth;

// 全角→半角
- (NSString*) stringToHalfwidth;

// カタカナ→ひらがな
- (NSString*) stringKatakanaToHiragana;

// ひらがな→カタカナ
- (NSString*) stringHiraganaToKatakana;

// ひらがな→ローマ字
- (NSString*) stringHiraganaToLatin;

// ローマ字→ひらがな
- (NSString*) stringLatinToHiragana;

// カタカナ→ローマ字
- (NSString*) stringKatakanaToLatin;

// ローマ字→カタカナ
- (NSString*) stringLatinToKatakana;

@end
