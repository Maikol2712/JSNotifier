/*
Copyright 2012 Jonah Siegle

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#import "JSNotifier.h"
#define _displaytime 4.f

@implementation JSNotifier {
}

+ (JSNotifier*)sharedView {
    static dispatch_once_t once;
    static JSNotifier *sharedView;
    dispatch_once(&once, ^ { sharedView = [[JSNotifier alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

- (void) initializeWithType:(JSNotifierShowType) type title:(NSString*) title mode:(JSNotifierShowMode) mode position:(JSNotifierPosition) position
{
    self.mode = mode;
    self.position = position;
    
    if (self.position == JSNotifierPositionBottom)
    {
        CGFloat y = self.mode == JSNotifierShowModeSlide ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.height - 40;
        self.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 40);
    }
    else
    {
        // Calculo el alto en función del statusbar y del navigationBar
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        id nav = [UIApplication sharedApplication].keyWindow.rootViewController;
        CGFloat navigationBarHeight = 0;
        if ([nav isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navc = (UINavigationController *) nav;
            if(!navc.navigationBarHidden) {
                navigationBarHeight = navc.navigationBar.frame.size.height;
            }
        }
        CGFloat y = self.mode == JSNotifierShowModeSlide ? statusBarHeight + navigationBarHeight - 36 : statusBarHeight + navigationBarHeight - 4;
        self.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 40);
    }
    
    [_accessoryView removeFromSuperview];
    [_txtLabel removeFromSuperview];
    
    self.backgroundColor = [UIColor clearColor];
    
    // Etiqueta
    _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, self.frame.size.width - 0, 20)];
    [_txtLabel setFont:[UIFont fontWithName: @"Helvetica" size: 16]];
    [_txtLabel setBackgroundColor:[UIColor clearColor]];
    [_txtLabel setNumberOfLines:2];
    [_txtLabel setTextColor:[UIColor whiteColor]];
    
    _txtLabel.layer.shadowOffset =CGSizeMake(0, -0.5);
    _txtLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _txtLabel.layer.shadowOpacity = 1.0;
    _txtLabel.layer.shadowRadius = 1;
    
    _txtLabel.layer.masksToBounds = NO;
    
    self.title = title;
    
    [self addSubview:_txtLabel];
    
    // Imagen
    if (type == JSNotifierShowTypeSuccess)
    {
        _accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotifyCheck"]];
    }
    else
    {
        _accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotifyX"]];
    }
    [_accessoryView setFrame:CGRectMake(12, ((self.frame.size.height -_accessoryView.frame.size.height)/2)+1, _accessoryView.frame.size.width, _accessoryView.frame.size.height)];
    
    [self addSubview:_accessoryView];
    
    // Adaptar tamaño etiqueta
    if (_accessoryView)
        [_txtLabel setFrame:CGRectMake(38, 12, self.frame.size.width - 38, 20)];
    else
        [_txtLabel setFrame:CGRectMake(8, 12, self.frame.size.width - 8, 20)];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
}

- (void)setTitle:(NSString *)title{
    
    [_txtLabel setText:title];
}

+ (void)showSuccessWithTitle:(NSString*) title mode:(JSNotifierShowMode) mode position:(JSNotifierPosition) position forTime:(float) time
{
    JSNotifier* sharedView = [JSNotifier sharedView];
    
    [sharedView initializeWithType:JSNotifierShowTypeSuccess title:title mode:mode position:position];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:sharedView];
    
    [sharedView showFor:time];
}

+ (void)showErrorWithTitle:(NSString*) title mode:(JSNotifierShowMode) mode position:(JSNotifierPosition) position forTime:(float) time
{
    JSNotifier* sharedView = [JSNotifier sharedView];
    
    [sharedView initializeWithType:JSNotifierShowTypeError title:title mode:mode position:position];
    
    [sharedView showFor:time];
}


- (void)show {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    
    if (self.mode == JSNotifierShowModeFade)
    {
        self.alpha = 1;
    }
    else
    {
        CGRect move = self.frame;
        if (self.position == JSNotifierPositionBottom)
        {
            move.origin.y -= 40.f;
        }
        else
        {
            move.origin.y += 34.f;
        }
        self.frame = move;
    }
    
    [UIView commitAnimations];
      
}

- (void)showFor:(float)time{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    
    if (self.mode == JSNotifierShowModeFade)
    {
        self.alpha = 1;
    }
    else
    {
        CGRect move = self.frame;
        if (self.position == JSNotifierPositionBottom)
        {
            move.origin.y -= 40.f;
        }
        else
        {
            move.origin.y += 34.f;
        }
        self.frame = move;
    }
    
    [UIView commitAnimations];
    
    [self hideIn:time];
}

- (void)hideIn:(float)seconds{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate: self]; //or some other object that has necessary method
        [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
        
        if (self.mode == JSNotifierShowModeFade)
        {
            self.alpha = 0;
        }
        else
        {
            CGRect move = self.frame;
            if (self.position == JSNotifierPositionBottom)
            {
                move.origin.y += 40.f;
            }
            else
            {
                move.origin.y -= 34.f;
            }
            self.frame = move;
        }
        [UIView commitAnimations];
    });

}

- (void)hide{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate: self]; //or some other object that has necessary method
    [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];

    if (self.mode == JSNotifierShowModeFade)
    {
        self.alpha = 0;
    }
    else
    {
        CGRect move = self.frame;
        if (self.position == JSNotifierPositionBottom)
        {
            move.origin.y += 40.f;
        }
        else
        {
            move.origin.y -= 34.f;
        }
        self.frame = move;
    }
    
    [UIView commitAnimations];
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Background color
    CGRect rectangle = CGRectMake(0,4,320,36);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f].CGColor);
    CGContextFillRect(context, rectangle);
    
    //First whiteColor
    CGContextSetLineWidth(context, 1.0);
    CGFloat componentsWhiteLine[] = {1.0, 1.0, 1.0, 0.35};
    CGColorRef Whitecolor = CGColorCreate(colorspace, componentsWhiteLine);
    CGContextSetStrokeColorWithColor(context, Whitecolor);
    
    CGContextMoveToPoint(context, 0, 4.5);
    CGContextAddLineToPoint(context, 320, 4.5);
    
    CGContextStrokePath(context);
    CGColorRelease(Whitecolor);
    
    //First whiteColor
    CGContextSetLineWidth(context, 1.0);
    CGFloat componentsBlackLine[] = {0.0, 0.0, 0.0, 1.0};
    CGColorRef Blackcolor = CGColorCreate(colorspace, componentsBlackLine);
    CGContextSetStrokeColorWithColor(context, Blackcolor);
    
    CGContextMoveToPoint(context, 0, 3.5);
    CGContextAddLineToPoint(context, 320, 3.5);
    
    CGContextStrokePath(context);
    CGColorRelease(Blackcolor);
    
    //Draw Shadow
    
    CGRect imageBounds = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 3.f);
	CGRect bounds = CGRectMake(0, 0, 320, 3);
	CGFloat alignStroke;
	CGFloat resolution;
	CGMutablePathRef path;
	CGRect drawRect;
	CGGradientRef gradient;
	NSMutableArray *colors;
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGPoint point;
	CGPoint point2;
	CGAffineTransform transform;
	CGMutablePathRef tempPath;
	CGRect pathBounds;
	CGFloat locations[2];
	resolution = 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Layer 1
	
	alignStroke = 0.0f;
	path = CGPathCreateMutable();
	drawRect = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 3.0f);
	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	CGPathAddRect(path, NULL, drawRect);
	colors = [NSMutableArray arrayWithCapacity:2];
	color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
	[colors addObject:(id)[color CGColor]];
	locations[0] = 0.0f;
	color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.18f];
	[colors addObject:(id)[color CGColor]];
	locations[1] = 1.0f;
	gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, locations);
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	transform = CGAffineTransformMakeRotation(-1.571f);
	tempPath = CGPathCreateMutable();
	CGPathAddPath(tempPath, &transform, path);
	pathBounds = CGPathGetPathBoundingBox(tempPath);
	point = pathBounds.origin;
	point2 = CGPointMake(CGRectGetMaxX(pathBounds), CGRectGetMinY(pathBounds));
	transform = CGAffineTransformInvert(transform);
	point = CGPointApplyAffineTransform(point, transform);
	point2 = CGPointApplyAffineTransform(point2, transform);
	CGPathRelease(tempPath);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	CGPathRelease(path);
	
	CGContextRestoreGState(context);
	CGColorSpaceRelease(space);

    CGColorSpaceRelease(colorspace);
}
    
@end
