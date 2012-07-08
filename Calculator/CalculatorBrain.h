//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Redkovich Roman on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)op;
- (void)releaseStack; 
- (void)pushVariable:(NSString *)variable;

@property (nonatomic, readonly) id program;
@property (nonatomic) NSDictionary *variablesSet;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@end
