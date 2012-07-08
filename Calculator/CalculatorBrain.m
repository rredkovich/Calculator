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

- (void)pushVariable:(NSString *)variable{
    
    [self.programStack addObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:0]  forKey:variable]]; //Is it correct to use NSNull instead of [NSNumber numberWIthDoule:0]?.. 
    
}


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
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) //check for operation or operand
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
        } else if([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffProgramStack:stack]);
            
        }else if ([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffProgramStack:stack]);
            
        }else if([@"sqrt" isEqualToString:operation]){
                double radicant = [self popOperandOffProgramStack:stack];
                if (radicant >= 0) {
                    result = sqrt(radicant);
                }else{
                result = 0;
            }
        }
    }else if ([topOfStack isKindOfClass:[NSDictionary class]]){
        result = topOfStack objectWithKey
        } (id)objectForKey:(id)aKey
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
