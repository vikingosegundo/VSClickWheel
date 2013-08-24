//
//  UIColor+VSClickWheelExtension.m
//  VSClickWheel
//
//  Created by Manuel Meyer on 18.08.12.
//  Copyright (c) 2012 Manuel Meyer. All rights reserved.
//

#import "UIColor+VSClickWheelExtension.h"

@implementation UIColor (VSClickWheelExtension)


- (CGColorSpaceModel) colorSpace
{
    CGColorRef clr = [self CGColor];
    CGColorSpaceRef clrSpace = CGColorGetColorSpace( clr );
    return  CGColorSpaceGetModel( clrSpace );    
}

-(UIColor *) darken: (CGFloat) amount
{
    UIColor *resultColor = self;
    CGColorSpaceModel model = [self colorSpace];
    int n = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *components = CGColorGetComponents(self.CGColor);

    switch (model) {
        case kCGColorSpaceModelRGB:
        {            
            CGFloat red     = components[0] - amount;
            CGFloat green   = components[1] - amount;
            CGFloat blue    = components[2] - amount;
            
            if (red < 0)    red   = 0;
            if (green < 0)  green = 0;
            if (blue < 0)   blue  = 0;
            
            CGFloat alpha;
            if (n > 3)
                alpha = components[3];
            else
                alpha = 1.0;
            
            resultColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            break;
        }
            
        default:
            break;
    }
    return resultColor;
}

@end
