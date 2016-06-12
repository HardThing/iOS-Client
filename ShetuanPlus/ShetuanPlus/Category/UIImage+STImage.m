//
//  UIImage+STImage.m
//  ShetuanPlus
//
//  Created by Jiao Liu on 10/16/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "UIImage+STImage.h"

@implementation UIImage (STImage)

+ (UIImage *)scaleImageBySize:(CGSize)size originalImage:(UIImage *)image
{
    float sizeRatio = size.width / size.height;
    float imageRatio = image.size.width / image.size.height;
    if (imageRatio > sizeRatio) {
        if (image.size.width > size.width) {
            float ratio = image.size.width / size.width * image.scale;
            return [UIImage imageWithCGImage:image.CGImage scale:ratio orientation:UIImageOrientationUp];
        }
        else
        {
            return image;
        }
    }
    else
    {
        if (image.size.height > size.height) {
            float ratio = image.size.height / size.height * image.scale;
            return [UIImage imageWithCGImage:image.CGImage scale:ratio orientation:UIImageOrientationUp];
        }
        else
        {
            return image;
        }
    }
    return image;
}

@end
