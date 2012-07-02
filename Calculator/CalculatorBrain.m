//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Redkovich Roman on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (strong, nonatomic) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain
@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack {
    if (!_operandStack) {
    _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

-(void) pushOperand:(double)operand{
    [self.operandStack addObject: [NSNumber numberWithDouble:operand]];    
}


-(double) popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    [self.operandStack removeLastObject];
    return [operandObject doubleValue];
    }

-(double) performOperation:(NSString *)operation{
    
    double result = 0;
    if ([operation isEqualToString:@"+"]){
        result = self.popOperand + self.popOperand;
        
    } else if ([@"*" isEqualToString:operation]){
        result = self.popOperand * self.popOperand;
        
    } else if ([@"-" isEqualToString:operation]){
       double secondNumber = self.popOperand;
       result = self.popOperand - secondNumber;

    }else if ([@"/" isEqualToString:operation]) {
        double divider = self.popOperand;
        if (divider) {
            result  = self.popOperand / divider;
        }
        
    }else if([@"sin" isEqualToString:operation]){
        result = sin(self.popOperand);
        
    }else if ([@"cos" isEqualToString:operation]){
        result = cos(self.popOperand);
        
    }else if([@"sqrt" isEqualToString:operation]){
        double radicant = self.popOperand;
        if (radicant >= 0) {
            result = sqrt(radicant);
        }else{
            result = 0;
        }
        
    }
        
    
    [self pushOperand:result];
    return result;
    
}

@end
