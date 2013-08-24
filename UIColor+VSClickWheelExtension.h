//
//  UIColor+VSClickWheelExtension.h
//  VSClickWheel
//
//  Created by Manuel Meyer on 18.08.12.
//  Copyright (c) 2012 Manuel Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VSClickWheelExtension)
- (CGColorSpaceModel) colorSpace;
-(UIColor *) darken: (CGFloat) amount;
@end
