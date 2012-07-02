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


@end

@implementation CalculatorViewController
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize floatNumberIsEntering = _floatNumberIsEntering;
@synthesize brain = _brain;


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
    
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
        
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
        
    self.display.text = [NSString stringWithFormat:@"%g", result];
     
}

- (IBAction)enterPressed 
{
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.floatNumberIsEntering = NO;
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
- (IBAction)piPressed { //this method just put pi into stak like any other number
    
    //check for 3 π * case
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }

    [self.brain pushOperand:M_PI];
    
}

@end
