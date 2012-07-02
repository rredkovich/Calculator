//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Redkovich Roman on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL floatNumberIsEntering;//Показывает есть ли на дисплее дробная точка
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) double pi; //Константа числа Пи
@property (nonatomic) BOOL piIsPressed; //Показывает была ли нажата кнопка pi


@end

@implementation CalculatorViewController
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize floatNumberIsEntering = _floatNumberIsEntering;
@synthesize brain = _brain;
@synthesize pi = _pi;
@synthesize piIsPressed = _piIsPressed;

-(double)  pi{
    
    return 3.14159265358979;
}


@synthesize display = _display;

-(CalculatorBrain *)brain{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc]init];
    }
    return _brain;
}



- (IBAction)digitPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber){
    self.display.text = [self.display.text stringByAppendingString: sender.currentTitle];
    }else {
        self.display.text = sender.currentTitle;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    //NSLog(@"Button %@ pressed", [sender currentTitle]);
    
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
        
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
        
    //NSLog(@"Operator %@ pressed", operation);
    self.display.text = [NSString stringWithFormat:@"%g", result];
     
}

- (IBAction)enterPressed 
{
    if (!self.piIsPressed){
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.floatNumberIsEntering = NO;
    //NSLog(@"Enter pressed");
    }else {
        double result = [self.display.text doubleValue] * self.pi;
        self.display.text = [NSString stringWithFormat:@"%g", result];
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
    
}
- (IBAction)dotPressed { 
    if (!self.floatNumberIsEntering) {
        //Проверяем нет ли уже в числе на дисплее точки
        NSString *textOnTheDisplay = self.display.text;
        NSRange range = [textOnTheDisplay rangeOfString:@"."];
        //Если нет, то позволяем ее "нарисовать"
        if (range.location == NSNotFound){
        self.display.text = [self.display.text stringByAppendingString: @"."];    
        self.floatNumberIsEntering = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
    
}
- (IBAction)piPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        double result = [self.display.text doubleValue] * self.pi;
        self.display.text = [NSString stringWithFormat:@"%g", result];
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.piIsPressed = NO;
        self.userIsInTheMiddleOfEnteringANumber = NO;
    } else {
        self.piIsPressed = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

@end
