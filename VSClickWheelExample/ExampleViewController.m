//
//  ViewController.m
//  VSClickWheelExample
//
//  Created by Manuel Meyer on 22.08.13.
//  Copyright (c) 2013 Manuel Meyer. All rights reserved.
//

#import "ExampleViewController.h"
#import "VSClickWheelView.h"

@interface ExampleViewController () <VSClickWheelViewDelegate>
@property (nonatomic, strong) NSMutableArray *digitLabels;
@property (nonatomic, strong) NSMutableArray *digitValues;

@property (nonatomic, strong) NSMutableArray *digitTapGestureControllers;
@property (nonatomic, strong) IBOutlet VSClickWheelView *clickWheel;
@property NSUInteger tappedDigitIdx;

@property NSUInteger value;

@end


static UIColor *kSelectionColor;
static NSUInteger kNumberOfDigits = 5;


@implementation ExampleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    kSelectionColor = [UIColor cyanColor];
    self.view.backgroundColor = [UIColor colorWithWhite:.85 alpha:1];
	self.value = 0;
    
    [self _setUpDigits];
    [self _setUpClickWheelView];
}


-(void)_setUpDigits
{
    self.digitLabels = [@[] mutableCopy] ;
    self.digitTapGestureControllers = [@[] mutableCopy];
    self.digitValues = [@[] mutableCopy];
    
    for (NSUInteger i =0 ; i< kNumberOfDigits; ++i) {
        [self.digitLabels addObject: [[UILabel alloc] initWithFrame:CGRectZero]];
        [self.digitTapGestureControllers addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(digitTapped:)]];
        [self.digitValues addObject:@0];
        
    }
    
    [self.digitLabels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        if(idx == [self.digitLabels count] -1) {
            label.frame = CGRectMake((self.view.frame.size.width / 2) - ([self.digitValues count] * 35 / 2) , 100, 35, 45);
            
        } else {
            UILabel *previousLabel = self.digitLabels[idx + 1];
            label.frame = CGRectOffset(previousLabel.frame, 35, 0);
            
        }
        
        [self.view addSubview:label];
        [label setFont:[UIFont fontWithName:[label.font fontName] size:35]];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@", self.digitValues[idx]];
        [label addGestureRecognizer:self.digitTapGestureControllers[idx]];
        [label setUserInteractionEnabled:YES];
    }];
    
    [self.digitLabels[0] setBackgroundColor:kSelectionColor];
}

-(void)_setUpClickWheelView
{
    CGFloat radius = 120.0;
    
    [_clickWheel setWheelRadius:radius];
    [_clickWheel setKnobRadius:45];
    [_clickWheel  setInnerStrokeWidth:4.0];
    [_clickWheel  setOuterStrokeWidth:4.0];
    [_clickWheel  setInnerStrokeColor:[UIColor grayColor]];
    [_clickWheel  setOuterStrokeColor:[UIColor grayColor]];
    [_clickWheel  setOuterStrokeColor:[UIColor grayColor]];
    [_clickWheel  setDelegate:self];
    [_clickWheel  setTicks:13];
    [_clickWheel  setFillColor:[UIColor colorWithWhite:.7 alpha:1]];
    [_clickWheel  setKnobFillColor1:[UIColor colorWithWhite:1.0 alpha:1]];
    [_clickWheel  setKnobFillColor2:[UIColor colorWithWhite:.5 alpha:1]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)activateDigitWithIndex:(NSUInteger) idx
{
    self.tappedDigitIdx = idx;
    
    [self.digitLabels enumerateObjectsUsingBlock:^(UILabel *l, NSUInteger idx, BOOL *stop) {
        if (idx == _tappedDigitIdx) {
            l.backgroundColor = kSelectionColor;
        } else {
            l.backgroundColor = [UIColor whiteColor];
        }
    }];
    
}

-(void)digitTapped:(UIGestureRecognizer *)sender
{
    [self activateDigitWithIndex:[self.digitTapGestureControllers indexOfObject:sender]];
}

-(void)reloadDigitLabels
{
    NSString *format = [NSString stringWithFormat:@"%%0%dd", [self.digitValues count]];
    NSString *string = [NSString stringWithFormat:format, self.value];
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[string length]];
    [string enumerateSubstringsInRange:NSMakeRange(0,[string length])
                               options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [reversedString appendString:substring];
                            }];
    [self.digitLabels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        obj.text = [reversedString substringWithRange:NSMakeRange(idx, 1)];
    }];
}



-(void)tickUpOnClickWheelView:(VSClickWheelView *)clickWheelView
{
    NSUInteger x = (NSUInteger)(self.value + pow(10, _tappedDigitIdx));
    if(x < pow(10, [self.digitValues count]))
        self.value = x;
    [self reloadDigitLabels];
}


-(void)tickDownOnClickWheelView:(VSClickWheelView *)clickWheelView
{
    NSInteger x = (NSInteger)(self.value - pow(10, _tappedDigitIdx));
    if(x > -1) {
        self.value = x;
    }
    [self reloadDigitLabels];
}

-(void)pressOnClickWheel:(VSClickWheelView *)clickWheelView
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"you selected"
                                                        message:[NSString stringWithFormat:@"%d", self.value]
                                                       delegate:nil
                                              cancelButtonTitle:@"dismiss"
                                              otherButtonTitles: nil];
    [alertView show];
    
    self.value = 0;
    [self reloadDigitLabels];
}
@end
