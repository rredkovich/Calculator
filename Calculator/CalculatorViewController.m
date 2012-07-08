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
@property (nonatomic) BOOL floatNumberIsEntering;
@property (nonatomic, strong) CalculatorBrain *brain;


@end

@implementation CalculatorViewController
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize floatNumberIsEntering = _floatNumberIsEntering;
@synthesize brain = _brain;


@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;

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
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:[sender currentTitle]];//add an operation sign to the history display
    double result = [self.brain performOperation:operation];
        
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.historyDisplay.text = [[[self.historyDisplay.text stringByAppendingString:@" = "] stringByAppendingString:[NSString stringWithFormat:@"%g", result]] stringByAppendingString:@" "]; //add result to the history display
     
}

- (IBAction)enterPressed 
{
        NSString *signOnTheDisplay = self.display.text;
    //check for variable or digit
    if ([signOnTheDisplay isEqualToString:@"x"] || [signOnTheDisplay isEqualToString:@"y"] || [signOnTheDisplay isEqualToString:@"z"]){ 
        [self.brain pushVariable:signOnTheDisplay];
    }else {
        [self.brain pushOperand:[signOnTheDisplay doubleValue]];        
        }
    
        self.historyDisplay.text = [[self.historyDisplay.text stringByAppendingString:self.display.text] stringByAppendingString:@" "]; //adding current operands to the History display
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.floatNumberIsEntering = NO;
}
- (IBAction)dotPressed { 
    if (!self.floatNumberIsEntering) {
        //checking for a dot on the display
        NSString *textOnTheDisplay = self.display.text;
        NSRange range = [textOnTheDisplay rangeOfString:@"."];
        //and put it on the display if it have not been found
        if (range.location == NSNotFound){
        self.display.text = [self.display.text stringByAppendingString: @"."];    
        self.floatNumberIsEntering = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
    
}
- (IBAction)piPressed { //this method just put pi into stack like any other number
    
    //check for 3 π * case
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }

    [self.brain pushOperand:M_PI];
    self.historyDisplay.text = [[self.historyDisplay.text stringByAppendingString:@"π"] stringByAppendingString:@" "]; //display π on the history display
    
    
}
- (IBAction)clearPressed {

    self.historyDisplay.text = @""; //clears the display

    self.display.text = @"0"; //clears the history display

    [self.brain releaseStack]; //releases operandStack    
    
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
