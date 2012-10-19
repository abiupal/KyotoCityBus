//
//  NSString+NSString_Henkan.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/08/08.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import "NSString+NSString_Henkan.h"

@implementation NSString (NSString_Henkan)

- (NSString *) stringTransformWithTransform:(CFStringRef)transform reverse:(Boolean)reverse
{
    NSMutableString *retStr = [[NSMutableString alloc] initWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(retStr), NULL, transform, reverse);
    return retStr;
}

- (NSString *) stringToFullwidth
{
    return [self stringTransformWithTransform:kCFStringTransformFullwidthHalfwidth
                                      reverse:true];
}

- (NSString *) stringToHalfwidth
{
    return [self stringTransformWithTransform:kCFStringTransformFullwidthHalfwidth
                                      reverse:false];
}

- (NSString *) stringKatakanaToHiragana
{
    return [self stringTransformWithTransform:kCFStringTransformHiraganaKatakana
                                      reverse:true];
}

- (NSString *) stringHiraganaToKatakana
{
    return [self stringTransformWithTransform:kCFStringTransformHiraganaKatakana
                                      reverse:false];
}

- (NSString *) stringHiraganaToLatin
{
    return [self stringTransformWithTransform:kCFStringTransformLatinHiragana
                                      reverse:true];
}

- (NSString *) stringLatinToHiragana
{
    return [self stringTransformWithTransform:kCFStringTransformLatinHiragana
                                      reverse:false];
}

- (NSString *) stringKatakanaToLatin
{
    return [self stringTransformWithTransform:kCFStringTransformLatinKatakana
                                      reverse:true];
}

- (NSString *) stringLatinToKatakana
{
    return [self stringTransformWithTransform:kCFStringTransformLatinKatakana
                                      reverse:false];
}

@end
