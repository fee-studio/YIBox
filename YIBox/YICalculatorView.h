//
// Created by efeng on 16/3/11.
// Copyright (c) 2016 buerguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YICalculatorViewDelegate <NSObject>
- (void)clickButtonTag:(int)tag;
@end



@interface YICalculatorView : UIView
{
	UILabel *lblDisplay2;
}


@property (nonatomic, weak) id<YICalculatorViewDelegate> delegate;

@property (nonatomic, strong) UILabel *lblDisplay2;
@property (nonatomic, strong) UIScrollView *scrollView;


- (void)setDisplayLblText:(double)value;
//- (NSString *)formatterNumber:(double)number;
//- (void)drawLblText:(NSString *)text writeInLastLbl:(BOOL)isLast nextLine:(BOOL)next isOperator:(BOOL)isOperator;
//- (void)drawLblCurNumberText:(double)curNumber operator:(int)operator writeInLastLbl:(BOOL)isLast nextLine:(BOOL)next;
- (void)drawLblCurNumberText:(double)curNumber operator:(int)operator
writeInLastLbl:(BOOL)isLast nextLine:(BOOL)next isOperator:(BOOL)isOperator isResult:(BOOL)isResult;
@end