
#import "VSClickWheelView.h"
#import "UIColor+VSClickWheelExtension.h"
typedef enum
{
	ClickWheelDirectionUnknow	=-1,
	ClickWheelDirectionCW		= 0,
	ClickWheelDirectionCCW		= 1
} ClickWheelDirection;

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2);
double AngleBetweenThreePoints(CGPoint point1,CGPoint point2, CGPoint point3);

@interface VSClickWheelView  ()
@property CGPoint startPoint, refPoint, endpoint, clickWheelCenter;
@property (nonatomic,strong) NSMutableArray *intermediateAngles;
@property double startAngle, tickAngle;
@property NSInteger tick, currentTick;
@property (nonatomic) ClickWheelDirection direction;
@property (nonatomic) BOOL touchAtInnerCircle;
@property (nonatomic, assign) CGPoint touchesPoint;
-(void)checkDirection;
-(void)configure;
-(UIColor *)transformMonochromColorToRGBColor:(UIColor *)color;
-(BOOL)colorDefinedInPatternSpace:(UIColor *)color;

@end

@implementation VSClickWheelView


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
        [self configure];
	}
	return self;
}

-(void)configure
{
    [self setUserInteractionEnabled:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    self.intermediateAngles = [NSMutableArray array];
    float x,y;
    
    x = self.frame.size.width/2.0;
    y = self.frame.size.height/2.0;
    
    self.clickWheelCenter = CGPointMake(x, y);	
}

-(void)dealloc
{
	self.knobRadius = 0;
	self.wheelRadius = 0;
	self.innerStrokeColor = nil;
	self.outerStrokeColor = nil;
	self.fillColor = nil;
    
    self.knobFillColor1 = nil;
    self.knobFillColor2 = nil;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self configure];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}


CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrtf(dx*dx + dy*dy );
};


double AngleBetweenThreePoints(CGPoint point1,CGPoint point2, CGPoint point3)
{
	CGPoint p1 = CGPointMake(point2.x - point1.x, -1*point2.y - point1.y *-1);
	CGPoint p2 = CGPointMake(point3.x -point1.x, -1*point3.y -point1.y*-1);
	double angle = atan2(p2.x*p1.y-p1.x*p2.x,p1.y*p2.y);
	//return angle /M_PI *180;
	
	return angle /(2* M_PI);
}

-(void)checkTick
{
    NSInteger t = [[self.intermediateAngles lastObject] doubleValue]/self.tickAngle;
    if (self.tick != t) {
        if (self.direction == ClickWheelDirectionCW) {
            [self.delegate tickUpOnClickWheelView:self];
        } else if (self.direction == ClickWheelDirectionCCW) {
            [self.delegate tickDownOnClickWheelView:self];
        }
        self.tick = t;
    }
}

-(void)checkDirection
{
	if([self.intermediateAngles count]>3){
		
		double n0, n1, n2 ,n3;
		
		n0 = [(self.intermediateAngles)[0] doubleValue];
		n1 = [(self.intermediateAngles)[1] doubleValue];
		n2 = [(self.intermediateAngles)[2] doubleValue];
		n3 = [(self.intermediateAngles)[3] doubleValue];
		
		if (n0 < n1 && n1 < n2 && n2 < n3) {
			self.direction = ClickWheelDirectionCW;
		} else if (n0 > n1 && n1 > n2 && n2 > n3 ) {
			self.direction = ClickWheelDirectionCCW;
		} else {
			self.direction = ClickWheelDirectionUnknow;
		}
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CGFloat distance = DistanceBetweenTwoPoints(self.clickWheelCenter, point);
	self.startPoint = point;
	self.startAngle = AngleBetweenThreePoints(self.clickWheelCenter, self.startPoint, point);
	if (distance > self.knobRadius && distance < self.wheelRadius) {
		self.touchAtInnerCircle = NO;
		if (self.ticks == 0) {
			[self setTicks:120];
		}
	} else if(distance < self.knobRadius-self.innerStrokeWidth/2){
		self.touchAtInnerCircle = YES;
        [self setNeedsDisplay];
        
        if ([self.delegate respondsToSelector:@selector(pressOnClickWheel:)]) {
            [self.delegate pressOnClickWheel:self];
        }
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!self.touchAtInnerCircle) {
		CGPoint point = [[touches anyObject] locationInView:self];
		CGFloat distance = DistanceBetweenTwoPoints(self.clickWheelCenter, point);
		
		if ( distance > self.knobRadius && distance < self.wheelRadius) {
			self.refPoint = CGPointMake(self.clickWheelCenter.x, self.clickWheelCenter.y +self.knobRadius);
			double angle = AngleBetweenThreePoints(self.clickWheelCenter, self.refPoint,point);
			[self.intermediateAngles addObject:@(angle)];
			if ([self.intermediateAngles count]>4)
				[self.intermediateAngles removeObjectAtIndex:0];
			[self checkDirection];
			[self checkTick];            
		}
        _touchesPoint = point;
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	if (self.touchAtInnerCircle) {

        double delayInSeconds = .15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.touchAtInnerCircle = NO;
            [self setNeedsDisplay];
        });
		
		CGFloat distance = DistanceBetweenTwoPoints(self.clickWheelCenter, point);
		if(distance < self.knobRadius-self.innerStrokeWidth/2){
			if ([self.delegate respondsToSelector:@selector(clickOnClickWheel:)]) {
				[self.delegate clickOnClickWheel:self];
			}
		}
	} 
	self.endpoint = point;
    _touchesPoint = CGPointZero;
    [self setNeedsDisplay];
}


void drawKnobWithGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id)startColor, (__bridge id)endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

-(void)fillEllipseInContext:(CGContextRef)context withRect:(CGRect) rect withColor:(UIColor *)fillColor
{
    const float* fillColors = CGColorGetComponents([fillColor CGColor]);
    
    if ([self colorDefinedInPatternSpace:fillColor]) {
    	CGContextSetFillColorSpace(context, CGColorGetColorSpace([fillColor CGColor]));
    	CGFloat alpha = 1.0f;
    	CGContextSetFillPattern(context, CGColorGetPattern([fillColor CGColor]), &alpha);
    	CGContextFillEllipseInRect(context, rect);
    } else {
    	CGContextSetRGBFillColor(context, fillColors[0],fillColors[1], fillColors[2], fillColors[3]);
    	CGContextFillEllipseInRect(context, rect);
        
    }
}

-(void)strokeEllipseInContext:(CGContextRef)context 
                     withRect:(CGRect)rect 
                    withColor:(UIColor *)strokeColor 
              withStrokeWidth:(CGFloat)strokeWidth
{
    const float* fillColors = CGColorGetComponents([strokeColor CGColor]);
    CGContextSetLineWidth(context, strokeWidth);
    if ([self colorDefinedInPatternSpace:strokeColor]) {
    	CGContextSetStrokeColorSpace(context, CGColorGetColorSpace([strokeColor CGColor]));
    	CGFloat alpha = 1.0f;
    	CGContextSetStrokePattern(context, CGColorGetPattern([strokeColor CGColor]), &alpha);
    	CGContextStrokeEllipseInRect(context, rect);
    } else {
    	CGContextSetRGBStrokeColor(context, fillColors[0],fillColors[1], fillColors[2], fillColors[3]);
        CGContextStrokeEllipseInRect(context, rect);
        
    }
}



-(UIColor *)transformMonochromColorToRGBColor:(UIColor *)color

{
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([color CGColor]);
    
    
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome){
		const float* colors = CGColorGetComponents([color CGColor]);
		color = [UIColor colorWithRed:colors[0]  
                                green:colors[0]  
                                 blue:colors[0] 
                                alpha:colors[1]];
	}
    return color;
    
}

-(BOOL)colorDefinedInPatternSpace:(UIColor *)color
{
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([color CGColor]);
    return CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelPattern;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	if (!self.innerStrokeColor) 
		self.innerStrokeColor = [UIColor colorWithRed:85.0/255.0 
												green:84.0/255.0 
												 blue:85.0/255.0 
												alpha: 1.0];	
	if (!self.outerStrokeColor) 
		self.outerStrokeColor = self.innerStrokeColor;
	if (!self.fillColor) 
		self.fillColor = [UIColor colorWithRed:169.0/255.0 
										 green:169.0/255.0 
										  blue:169.0/255.0 
										 alpha:1.0];
    
    if (!self.knobFillColor1) self.knobFillColor1 = self.fillColor;
    if (!self.knobFillColor2) self.knobFillColor2 = self.knobFillColor1;
    
    if (!self.knobPressedFillColor1)
        self.knobPressedFillColor1 = self.knobFillColor1;
    if (!self.knobPressedFillColor2)
        self.knobPressedFillColor2 = [self.knobFillColor2 darken:.2];
    
	float x,y;
	CGFloat radius;
	CGRect innerCircleFrame;
    
	radius = 	self.wheelRadius+self.outerStrokeWidth;
	x = self.clickWheelCenter.x-self.wheelRadius-self.outerStrokeWidth;
	y = self.clickWheelCenter.y-self.wheelRadius-self.outerStrokeWidth;
    CGRect outerCircleFrame = CGRectMake(x+ self.outerStrokeWidth/2, 
										 y+ self.outerStrokeWidth/2, 
										 radius*2, radius*2);
    
	CGContextAddArc(contextRef, self.clickWheelCenter.x, self.clickWheelCenter.y, self.wheelRadius, 0, 2*M_PI, 1);
	CGContextEOClip(contextRef);
    
    [self fillEllipseInContext:contextRef withRect:outerCircleFrame withColor:self.fillColor];    
	radius = 	self.wheelRadius;
	x = self.clickWheelCenter.x-self.wheelRadius+self.outerStrokeWidth/2;
	y = self.clickWheelCenter.y-self.wheelRadius+self.outerStrokeWidth/2;
	outerCircleFrame = CGRectMake(x, y, (radius-self.outerStrokeWidth/2)*2, (radius-self.outerStrokeWidth/2)*2);
    [self strokeEllipseInContext:contextRef withRect:outerCircleFrame withColor:self.outerStrokeColor withStrokeWidth:self.outerStrokeWidth];
    
	
	radius = 	self.knobRadius;
	x = self.clickWheelCenter.x-self.knobRadius;
	y = self.clickWheelCenter.y-self.knobRadius;
	innerCircleFrame = CGRectMake(x, y, radius*2, radius*2);
    
    if (!self.touchAtInnerCircle) {
        drawKnobWithGradient(contextRef, innerCircleFrame, [self.knobFillColor1 CGColor], [self.knobFillColor2 CGColor]);
    } else {
        drawKnobWithGradient(contextRef, innerCircleFrame, [self.knobPressedFillColor1 CGColor], [self.knobPressedFillColor2 CGColor]);
    }
    
    
	radius = 	self.knobRadius;
	x = self.clickWheelCenter.x-self.knobRadius;
	y = self.clickWheelCenter.y-self.knobRadius;	
	innerCircleFrame = CGRectMake(x,y, radius*2, radius*2);
    
    [self strokeEllipseInContext:contextRef
                        withRect:innerCircleFrame 
                       withColor:self.innerStrokeColor 
                 withStrokeWidth:self.innerStrokeWidth];
}


-(void)setTicks:(NSInteger)ticks
{
	_ticks =ticks;
	self.tickAngle = 1.0/_ticks;
	
}

-(void) setColor:(UIColor *)color onColor:(UIColor *)memberColor
{
    memberColor = [self transformMonochromColorToRGBColor:color];
    [self setNeedsDisplay];
}

-(void)setOuterStrokeColor:(UIColor *)outerStrokeColor
{
    _outerStrokeColor = [self transformMonochromColorToRGBColor:outerStrokeColor];
    [self setNeedsDisplay];
}

-(void)setInnerStrokeColor:(UIColor *)innerStrokeColor
{
    _innerStrokeColor = [self transformMonochromColorToRGBColor:innerStrokeColor];
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor= [self transformMonochromColorToRGBColor:fillColor];
}

-(void)setKnobFillColor1:(UIColor *)knobFillColor1
{
    _knobFillColor1  = [self transformMonochromColorToRGBColor:knobFillColor1];
}

-(void)setKnobFillColor2:(UIColor *)knobFillColor2
{
    _knobFillColor2 = [self transformMonochromColorToRGBColor:knobFillColor2];
}

@end
