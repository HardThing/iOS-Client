//
//  NSString+STExtension.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/5/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "NSString+st_extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (st_extension)

+ (BOOL)isValidAccount:(NSString *)account{
    if (account.length == 0) {
        return NO;
    }
    
    NSString *regExPattern = @"^[a-z0-9_-]{3,16}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:account options:0 range:NSMakeRange(0, [account length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isValidEmailAddress:(NSString *)emailStr
{
    if([emailStr length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailStr options:0 range:NSMakeRange(0, [emailStr length])];

    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    if (mobileNum.length != 11) {
        return NO;
    }
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isValidVerifyCode:(NSString *)verifyCode{
    NSString *regexVerify = @"^\\d{6}$";
    NSPredicate *predicateCode = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexVerify];
    if ([predicateCode evaluateWithObject:verifyCode] == YES) {
        return YES;
    }
    return NO;
}
//该字符串是否为空
+(BOOL)isEmpty:(NSString *)string{
    if (string) {
       
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] > 0) {
            return NO;
        }
    }
    return YES;
}


//去掉前后的空格
-(NSString *)trim{
    if (self) {
        NSString *trimedString = [self stringByStrippingWhitespace];
        return trimedString;
    }
    return @"";
}

- (BOOL)isContainsString:(NSString*)other {
    BOOL isContains = NO;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        isContains = [self containsString:other];
    else{
        NSRange range = [self rangeOfString:other];
        isContains = (range.length != 0);
    }
    return isContains;
}


- (NSString *)MD5 {
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}


-(NSString *)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data 	 = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


-(NSString *)reverse {
    NSInteger length = [self length];
    unichar *buffer = calloc(length, sizeof(unichar));
    
    // TODO(gabe): Apparently getCharacters: is really slow
    [self getCharacters:buffer range:NSMakeRange(0, length)];
    
    for(int i = 0, mid = ceil(length/2.0); i < mid; i++) {
        unichar c = buffer[i];
        buffer[i] = buffer[length-i-1];
        buffer[length-i-1] = c;
    }
    
    NSString *s = [[NSString alloc] initWithCharacters:buffer length:length];
    free(buffer);
    return s;
}


-(NSUInteger)countWords {
    
    __block NSUInteger wordCount = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              wordCount++;
                          }];
    return wordCount;
}



-(NSString *)stringByStrippingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
    NSString *rightPart = [self substringFromIndex:from];
    return [rightPart substringToIndex:to-from];
}


-(NSString *)URLEncode {
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)self,
                                                                  NULL,
                                                                  CFSTR(":/?#[]@!$&'()*+,;="),
                                                                  kCFStringEncodingUTF8);
    return [NSString stringWithString:(__bridge_transfer NSString *)encoded];
}

-(NSString *)URLDecode {
    
    CFStringRef decoded = CFURLCreateStringByReplacingPercentEscapes( kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     CFSTR(":/?#[]@!$&'()*+,;=") );
    return [NSString stringWithString:(__bridge_transfer NSString *)decoded];
}


-(NSString *)CamelCaseToUnderscores:(NSString *)input {
    
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"%s%C", (idx == 0 ? "" : "_"), (unichar)(c ^ 32)];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

-(NSString *)UnderscoresToCamelCase:(NSString*)underscores {
    
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [underscores length]; idx += 1) {
        unichar c = [underscores characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

-(NSString *)CapitalizeFirst:(NSString *)source {
    
    if ([source length] == 0) {
        return source;
    }
    return [source stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                           withString:[[source substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}


#pragma mark - Boolean Helpers

-(BOOL)contains:(NSString *)string {
    return [self isContainsString:string];
}
@end
