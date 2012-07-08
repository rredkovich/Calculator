//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Redkovich Roman on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (strong, nonatomic) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

-(NSMutableArray *)programStack {
    if (!_programStack) {
    _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

-(void) pushOperand:(double)operand{
    [self.programStack addObject: [NSNumber numberWithDouble:operand]];    
}


/*-(double) popOperand {
    NSNumber *operandObject = [self.programStack lastObject];
    [self.programStack removeLastObject];
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
*/

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

-(void) releaseStack{
    
    [self.programStack removeAllObjects];
}

@end
