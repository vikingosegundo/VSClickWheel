//
//  ViewController.m
//  VSClickWheel
//
//  Created by Manuel Meyer on 14.08.12.
//  Copyright (c) 2012 Manuel Meyer. All rights reserved.
//

#import "ViewController.h"
#import "VSClickWheelView.h"
@interface ViewController () <VSClickWheelViewDelegate>{
    NSInteger number;
}
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController
@synthesize label = _label;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat radius = 120.0;
    
    CGRect frame = CGRectMake(self.view.center.x-radius, self.view.frame.size.height-radius*2, radius*2, radius*2);
    
    VSClickWheelView *clickWheel = [[VSClickWheelView alloc] initWithFrame:frame];
    [self.view addSubview:clickWheel];
    
    [clickWheel setWheelRadius:radius];
    [clickWheel setKnobRadius:45];
    [clickWheel setInnerStrokeWidth:4.0];
    [clickWheel setOuterStrokeWidth:4.0];
    [clickWheel setInnerStrokeColor:[UIColor grayColor]];
    [clickWheel setOuterStrokeColor:[UIColor grayColor]];
    [clickWheel setOuterStrokeColor:[UIColor grayColor]];
    [clickWheel setDelegate:self];
    [clickWheel setTicks:10];
    [clickWheel setFillColor:[UIColor greenColor]];
    [clickWheel setKnobFillColor1:[UIColor colorWithWhite:1.0 alpha:1]];
    [clickWheel setKnobFillColor2:[UIColor redColor]];
//    [clickWheel setKnobPressedFillColor1:[UIColor colorWithWhite:1.0 alpha:1]];
//    [clickWheel setKnobPressedFillColor2:[UIColor darkGrayColor]];
    
    CGFloat labelWidth = 200.0;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 100, 50.0, labelWidth, 44.0)];
    [self.view addSubview:_label];
    number = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)clickOnClickWheel:(VSClickWheelView *)clickWheelView
{
    self.label.text = nil;
}

-(void)tickDownOnClickWheelView:(VSClickWheelView *)clickWheelView
{
    NSLog(@"down");
    --number;
    [self refreshLabel];
    
}

-(void)tickUpOnClickWheelView:(VSClickWheelView *)clickWheelView
{
    NSLog(@"up");
    ++number;
    [self refreshLabel];
}

- (void) refreshLabel{
    self.label.text = [NSString stringWithFormat:@"%i", number];
}

-(void)pressOnClickWheel:(VSClickWheelView *)clickWheelView{
    NSLog(@"press");
}

@end
