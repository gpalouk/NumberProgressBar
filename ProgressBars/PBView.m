//
//  PBView.m
//  ProgressBars
//
//  Created by Ming-Zhe on 14-5-3.
//  Copyright (c) 2014年 Ming-Zhe. All rights reserved.
//

#import "PBView.h"


@interface PBViewLayer : CALayer
@property (nonatomic, strong) UIColor* progressColor;
@property (nonatomic, strong) UIColor* progressBackColor;
@property (nonatomic) CGFloat progress;
@end

@implementation PBViewLayer

@dynamic progressColor;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
  return [key isEqualToString:@"progress"] ? YES : [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
  // some needed variable
  CGFloat fontSize = 20.0;
  NSInteger int_progress = (int)roundf(self.progress * 100);
  NSString *text = [NSString stringWithFormat:@"%li kWh", int_progress];
  const char * c_text = [text UTF8String];
  CGFloat textWidth = 4.0 + strlen(c_text) * (fontSize/2) + 8.0 + 4.0;
  
  // right bar
  CGRect barRect = CGRectInset(self.bounds, 0, 4.0f);
  CGFloat maxWidth = barRect.size.width;
  barRect.size.width = self.progress * barRect.size.width;
  if (self.progressBackColor)
    CGContextSetFillColorWithColor(context, self.progressBackColor.CGColor);
  else
    CGContextSetRGBFillColor(context, 220.0/255.0f, 220.0/255.0f, 220.0/255.0f, 0.0f);
  CGContextMoveToPoint(context, barRect.origin.x + maxWidth, barRect.origin.y);
  CGContextAddLineToPoint(context, barRect.origin.x + maxWidth, barRect.origin.y
                          + barRect.size.height);
  CGContextAddLineToPoint(context, barRect.origin.x + barRect.size.width + textWidth, barRect.origin.y + barRect.size.height);
  CGContextAddLineToPoint(context, barRect.origin.x + barRect.size.width + textWidth, barRect.origin.y);
  CGContextAddLineToPoint(context, barRect.origin.x + maxWidth, barRect.origin.y);
  CGContextFillPath(context);
  
  // left bar
  CGRect progressRect = CGRectInset(self.bounds, 0, 4.0f);
  progressRect.size.width = self.progress * progressRect.size.width;
  CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
  CGContextMoveToPoint(context, progressRect.origin.x, progressRect.origin.y);
  CGContextAddLineToPoint(context, progressRect.origin.x, progressRect.origin.y + progressRect.size.height);
  CGContextAddLineToPoint(context, MIN(progressRect.origin.x + progressRect.size.width, maxWidth - textWidth + 4), progressRect.origin.y + progressRect.size.height);
  CGContextAddLineToPoint(context, MIN(progressRect.origin.x + progressRect.size.width, maxWidth - textWidth + 4), progressRect.origin.y);
  CGContextAddLineToPoint(context, progressRect.origin.x, progressRect.origin.y);
  CGContextFillPath(context);
  
  // text
  CGRect textRect = self.bounds;
  CGFloat current = self.progress * textRect.size.width;
  CGContextSetTextDrawingMode(context, kCGTextStroke);
  CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
  CGContextSelectFont(context, "HelveticaNeue-UltraLight", fontSize, kCGEncodingMacRoman);
  CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
  CGContextSetTextMatrix(context, transform);
  CGContextShowTextAtPoint(context, MIN(textRect.origin.x + current + 5.0, maxWidth - textWidth + 8.0), textRect.origin.y + (CGRectGetHeight(textRect)/2+fontSize/3), c_text, strlen(c_text));
  
}


@end


@implementation PBView

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self initialize];
  }
  return self;
}

- (void)initialize
{
  self.backgroundColor = [UIColor clearColor];
}

- (void)didMoveToWindow
{
  self.progressLayer.contentsScale = self.window.screen.scale;
}

+ (Class)layerClass
{
  return [PBViewLayer class];
}

- (PBViewLayer *)progressLayer
{
  return (PBViewLayer *)self.layer;
}


#pragma mark Getters & Setters

- (CGFloat)progress
{
  return self.progressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
  [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
  [self.progressLayer removeAnimationForKey:@"progress"];
  CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
  
  if (animated) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = fabsf(self.progress - pinnedProgress) + 0.1f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:self.progress];
    animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
    [self.progressLayer addAnimation:animation forKey:@"progress"];
  }
  else {
    [self.progressLayer setNeedsDisplay];
  }
  
  self.progressLayer.progress = pinnedProgress;
}

- (UIColor *)progressColor
{
  return self.progressLayer.progressColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
  self.progressLayer.progressColor = progressColor;
  [self.progressLayer setNeedsDisplay];
}

- (UIColor *)progressBackColor
{
  return self.progressLayer.progressBackColor;
}

- (void)setProgressBackColor:(UIColor *)progressBackColor
{
  self.progressLayer.progressBackColor = progressBackColor;
  [self.progressLayer setNeedsDisplay];
}


@end
