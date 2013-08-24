

#import <UIKit/UIKit.h>

@class VSClickWheelView;

/**A ClickWheel delegate must fulfill this protocol*/
@protocol VSClickWheelViewDelegate <NSObject>
@optional
/**Will be called, if a tick up was triggerd
 
 optional
 @param clickWheelView The ClickWheel, that triggered the tick
 */
-(void)tickUpOnClickWheelView:(VSClickWheelView *)clickWheelView;
/**Will be called, if a tick down was triggerd
 
 optional
 @param clickWheelView The ClickWheel, that triggered the tick
 */
-(void)tickDownOnClickWheelView:(VSClickWheelView *)clickWheelView;
/**Will be called, if a tocuhn up inside was triggerd on the knob.
 
 optional
 @param clickWheelView The ClickWheel, that triggered the touch up inside event
 */
-(void)clickOnClickWheel:(VSClickWheelView *)clickWheelView;

-(void)pressOnClickWheel:(VSClickWheelView *)clickWheelView;
@end


/**
 A ClickWheel as known from iPod Classic
 
 A ClickView will report ticks up, ticks down and touch up inside events to it delegates, conforming to GFClickWheelViewDelegate
 */
@interface VSClickWheelView : UIView 
/** the delegate will be informed about each "tick"
 @see GFClickWheelViewDelegate
 */
@property (nonatomic, weak)IBOutlet id<VSClickWheelViewDelegate> delegate;
/**the radius of the knob, a area, that will report touches as enter*/
@property float knobRadius;
/**The radius of the wheel*/
@property float wheelRadius;
/**Number of ticks that will be recognized in one complet circle*/
@property (nonatomic) NSInteger ticks;
/**The stroke color of the inner circle
 
 Possible color spaces: 
 
 - RGB
 - monochromic 
 
      [UIColor colorWithWhite:.46 alpha:1.0]
 
 - pattern
 
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern2.png"]]
 */
@property (nonatomic,strong) UIColor *innerStrokeColor;

/**The stroke color of the wheel
 
 Possible color spaces: 
 
 - RGB
 - monochromic 
 
      [UIColor colorWithWhite:.46 alpha:1.0]
 
 - pattern
 
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern2.png"]]
 */
@property (nonatomic,strong) UIColor *outerStrokeColor;
/**The fill color of the inner circle
 
 Possible color spaces: 
 
 - RGB
 - monochromic 
 
        [UIColor colorWithWhite:.46 alpha:1.0]
 
 - pattern
 
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern2.png"]]
 */
@property (nonatomic,strong) UIColor *fillColor;
/**The upper left gradient color of the knob
 
 Possible color spaces: 
 
 - RGB
 - monochromic
 
        [UIColor colorWithWhite:.46 alpha:1.0]

 @warning as this color is a gradient component, you can't assign a pattern color scape color to it
 */
@property (nonatomic, strong) UIColor *knobFillColor1;
/**The down right gradient color of the knob
 Possible color spaces: 
 
 - RGB
 - monochromic
 
       [UIColor colorWithWhite:.46 alpha:1.0]
 
 @warning as this color is a gradient component, you can't assign a pattern color scape color to it
 */
@property (nonatomic, strong) UIColor *knobFillColor2;
@property (nonatomic, strong) UIColor *knobPressedFillColor1;
@property (nonatomic, strong) UIColor *knobPressedFillColor2;


/**the width of the inner stroke*/
@property (nonatomic) CGFloat innerStrokeWidth;
/**the width of the wheel stroke*/
@property (nonatomic) CGFloat outerStrokeWidth;


@end
