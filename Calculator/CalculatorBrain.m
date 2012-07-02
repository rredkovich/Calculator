//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Redkovich Roman on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//Куча закоменченных NSLog могут быть использованы для отловки багов

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
    //NSLog(@"pushOperand added %@", [self.operandStack lastObject]);
    
}


-(double) popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    //NSLog(@"last object in operandStack berfore removeLastObject: %@",[self.operandStack lastObject]);
    [self.operandStack removeLastObject];
    //NSLog(@"last object in operandStack after removeLastObject: %@",[self.operandStack lastObject]);
    //NSLog (@"popOperand returned %f", [operandObject doubleValue]);
    return [operandObject doubleValue];
    }

-(double) performOperation:(NSString *)operation{
    
    double result = 0;
    if ([operation isEqualToString:@"+"]){
        result = self.popOperand + self.popOperand;
       // NSLog(@"Operation + choosen");
        //NSLog(@"result = %g", result);
    } else if ([@"*" isEqualToString:operation]){
        result = self.popOperand * self.popOperand;
        //NSLog(@"Operation * choosen");
        //NSLog(@"result = %g", result);
    } else if ([@"-" isEqualToString:operation]){
       double secondNumber = self.popOperand;
       result = self.popOperand - secondNumber;
        //NSLog(@"Operation - choosen");
        //NSLog(@"result = %g", result);
    }else if ([@"/" isEqualToString:operation]) {
        double divider = self.popOperand;
        if (divider) {
            result  = self.popOperand / divider;
            //NSLog(@"Operation - choosen");
            //NSLog(@"result = %g", result);
        }
    }else if([@"sin" isEqualToString:operation]){
        result = sin(self.popOperand);
    }else if ([@"cos" isEqualToString:operation]){
        result = cos(self.popOperand);
    }else if([@"sqrt" isEqualToString:operation]){
        result = sqrt(self.popOperand);
    }
        
    
    [self pushOperand:result];
    //NSLog(@"Last value in stack %@", [self.operandStack lastObject]);
    return result;
    
}

@end
