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
@synthesize variablesSet = _variablesSet;
@synthesize programStack = _programStack;

+(BOOL) isAnOperand:(NSString *)operand {
    BOOL result = NO;
    
    if ([operand isKindOfClass:[NSString class]]&&
        ([operand isEqualToString:@"+"]||
         [operand isEqualToString:@"-"] || 
         [operand isEqualToString:@"*"] || 
         [operand isEqualToString:@"/"] ||
         [operand isEqualToString:@"sqrt"] ||
         [operand isEqualToString:@"cos"]||
         [operand isEqualToString:@"sin"]||
         [operand isEqualToString:@"π"])) 
        result = YES;
    
    return result;    
}

+ (BOOL) isAVariable:(NSString *)variable{
    BOOL result = NO;
    
    if ([variable isKindOfClass:[NSString class]]&&
        ([variable isEqualToString:@"x"]||
         [variable isEqualToString:@"y"] || 
         [variable isEqualToString:@"z"])) 
        result = YES;
    
    return result;
    
}

-(NSDictionary *)variablesSet{
    if(_variablesSet){
        _variablesSet = [[NSDictionary alloc] init];
    }
    return _variablesSet;
}

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

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack{
    NSString *result;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    
    if ([topOfStack isKindOfClass:[NSNumber class] ]) {         //topOfStack is a Number case
        result = [NSString stringWithFormat:@"%@",topOfStack];
        
    }else if ([topOfStack isKindOfClass:[NSString class]] && [[self class] isAVariable:topOfStack] ) { //topOfStack is a variable 
        result = topOfStack;
    
    }else if ([[self class] isAnOperand:topOfStack] && ( [topOfStack isEqualToString:@"cos"] || [topOfStack isEqualToString:@"sin"] || [topOfStack isEqualToString:@"sqrt"])) {
        result =  [[[topOfStack stringByAppendingString:@"("] stringByAppendingString:topOfStack] stringByAppendingString:@")"]; //topOfStack is cos/sin/sqrt
        //result =  [[[topOfStack stringByAppendingString:@"("] stringByAppendingString:[NSString stringWithFormat:@"%@",[self runProgram:stack]]] stringByAppendingString:@")"]; неудачная попытка вывести под операндом конечное число

        
    }else if ([[self class] isAnOperand:topOfStack] && ( [topOfStack isEqualToString:@"+"] || [topOfStack isEqualToString:@"-"])) { //topOfStack is + or -

        NSString *secondOperand = [[NSString alloc] initWithString:[[self class] descriptionOfTopOfStack:stack]];
        result = [[[[@"(" stringByAppendingString:[[self class] descriptionOfTopOfStack:stack]] stringByAppendingString:topOfStack] stringByAppendingString:secondOperand] stringByAppendingString:@")"];
        

    }else if ([[self class] isAnOperand:topOfStack] && ( [topOfStack isEqualToString:@"*"] || [topOfStack isEqualToString:@"/"])) { 

                NSString *secondOperand = [[NSString alloc] initWithString:[[self class] descriptionOfTopOfStack:stack]];
               result =  [[[[self class] descriptionOfTopOfStack:stack] stringByAppendingString:topOfStack] stringByAppendingString:secondOperand];  
             }
    return result;
    
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *result = [[NSString alloc] init];
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSMutableArray class]]){
        stack = program;
    } else if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    while ([stack count]){
       //NSString *first = [[NSString alloc] initWithString:[[self class] descriptionOfTopOfStack:stack]];
        result = [result stringByAppendingString:[[self class] descriptionOfTopOfStack:stack]];
    }
    
    return result;
}

-(void) pushOperand:(double)operand{
    [self.programStack addObject: [NSNumber numberWithDouble:operand]];    
}

- (void)pushVariable:(NSString *)variable{
    
    [self.programStack addObject:variable]; 
    
}

- (NSString *)giveSelfDescription{
    return [[self class] descriptionOfProgram:self.program];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:self.variablesSet];
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
        }else if([topOfStack isEqualToString:@"x"] || [topOfStack isEqualToString:@"y"] || [topOfStack isEqualToString:@"z"]){
            result = 0;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    
    double result;
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]] && variableValues) {
        stack = [program mutableCopy];
        
        //search and replace variables
        for (int i=0; i <= ([stack count] - 1); i++){
            if ([[stack objectAtIndex:i ] isKindOfClass: [NSString class]]){
                if ([[stack objectAtIndex:i ] isEqualToString:@"x"]) {
                    [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:@"x"]];               
                }else if ([[stack objectAtIndex:i ] isEqualToString:@"y"]) {
                    [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:@"y"]]; 
                }else if ([[stack objectAtIndex:i ] isEqualToString:@"z"]) {
                    [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:@"z"]]; 
                }
                
            }
        }
        result = [self popOperandOffProgramStack:stack];
        
    } else if ([program isKindOfClass:[NSArray class]]){
        result =  [self runProgram:program];
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
