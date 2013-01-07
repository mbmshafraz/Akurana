//
//  UIImageView+Akurana.m
//  Akurana
//
//  Created by Mohamed Shafraz on 07/01/2013.
//  Copyright (c) 2013 Shafraz Buhary. All rights reserved.
//

#import "UIImageView+Akurana.h"

@implementation UIImageView (Akurana)

- (void)setImageWithoutStrach:(UIImage *)image
{
    
    CGRect frame = self.frame;
    
    CGFloat frameWidth = frame.size.width;
    CGFloat frameHeight = frame.size.height;
    CGFloat imageWidthHeightRasio = image.size.width / image.size.height;
    CGFloat mult = (frameWidth / imageWidthHeightRasio) < frameHeight
    ? (frameWidth / imageWidthHeightRasio) : frameHeight;
    
    frame.size.width = mult * imageWidthHeightRasio;
    frame.size.height = mult;
    
    frame.origin.x = frame.origin.x + (frameWidth - frame.size.width) / 2;
    frame.origin.y = frame.origin.y + (frameHeight - frame.size.height) / 2;
    
    self.image = image;
    
    self.frame = frame;
}

@end
