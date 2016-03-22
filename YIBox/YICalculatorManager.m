//
//  YICalculatorManager.m
//  FYCalculator
//
//  Created by efeng on 14-8-28.
//  Copyright (c) 2014年 buerguo. All rights reserved.
//

#import "YICalculatorManager.h"
#import "YICalculatorView.h"


@implementation YICalculatorManager

+ (instancetype)sharedManager {
    static YICalculatorManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YICalculatorManager alloc] init];
    });

    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxLengthDecimal = 6;
        self.maxLengthNumber = 12;
        self.enableArithmeticPriority = NO;
        self.inputs = [NSMutableArray array];

        [self resetDefaultValue];
    }
    return self;
}

- (void)resetDefaultValue {
    self.currentNumber = 0;
    self.isDecimal = NO;
    self.decimals = 0;
    self.tempNumber = 0;
    self.operator = 0;
}

#pragma mark -

- (void)inputObject:(int)tag {
    [self.inputs addObject:@(tag)];
}

- (double)calCurrentNumberWithDigit:(int)digit {
    // 输入新的数字
    int lastInput = [[self.inputs lastObject] intValue];
    if ((lastInput >= OPERATOR_ADD && lastInput <= OPERATOR_EQUAL) // 二元操作符
            || (lastInput >= OPERATOR_DELETE && lastInput <= OPERATOR_NEGATIVE)) { // 一元操作符
        self.tempNumber = self.currentNumber;
        self.currentNumber = 0;
        self.isDecimal = NO;
        self.decimals = 0;
    }
	
//	if (digit == 10) {
//		self.isDecimal = YES;
////		return self.currentNumber;
//	}

	BOOL next = NO;
	if (lastInput == OPERATOR_EQUAL
		|| lastInput == OPERATOR_CLEAR
		|| (lastInput >= OPERATOR_DELETE && lastInput <= OPERATOR_NEGATIVE)) {
		next = YES;
	}
	BOOL inLast = NO;
	if ((lastInput >= DIGIT_ZERO && lastInput <= DIGIT_NINE )
		|| lastInput == DIGIT_DOT) {
		inLast = YES;
	}
	
	[self configUIControllerWriteResult:NO writeInLastLbl:inLast writeNextLine:next writeIsOperator:NO];
	
//	if (self.currentNumber == 0 && self.isDecimal == NO) {
//		[self configUIControllerWriteResult:NO writeInLastLbl:NO writeNextLine:next writeIsOperator:NO];
//	} else {
//		[self configUIControllerWriteResult:NO writeInLastLbl:YES writeNextLine:next writeIsOperator:NO];
//	}
	
	if (digit == 10) {
		self.isDecimal = YES;
		return self.currentNumber;
	}

    if (self.isDecimal) {
        self.decimals++;
        if (self.currentNumber >= 0) {
            self.currentNumber = self.currentNumber + digit * pow(10, (-1) * self.decimals);
        } else {
            self.currentNumber = self.currentNumber - digit * pow(10, (-1) * self.decimals);
        }
    } else {
        if (self.currentNumber >= 0) {
            self.currentNumber = self.currentNumber * 10 + digit;
        } else {
            self.currentNumber = self.currentNumber * 10 - digit;
        }
    }

    return self.currentNumber;
}

- (double)calCurrentNumberWithBinaryOperator:(int)tag {
    int lastInput = [[self.inputs lastObject] intValue];
	if (self.operator == OPERATOR_NULL) {
		self.operator = tag;
		[self configUIControllerWriteResult:NO writeInLastLbl:NO writeNextLine:YES writeIsOperator:YES];
	}else if (lastInput >= OPERATOR_ADD && lastInput <= OPERATOR_DIVISION) {
        self.operator = tag;
		[self configUIControllerWriteResult:NO writeInLastLbl:NO writeNextLine:NO writeIsOperator:YES];
    } else {
		[self configUIControllerWriteResult:YES writeInLastLbl:NO writeNextLine:YES writeIsOperator:YES];
        switch (self.operator) {
            case OPERATOR_ADD:
                self.currentNumber = self.tempNumber + self.currentNumber;
                break;
            case OPERATOR_MINUS:
                self.currentNumber = self.tempNumber - self.currentNumber;
                break;
            case OPERATOR_MULTIPLE:
                self.currentNumber = self.tempNumber * self.currentNumber;
                break;
            case OPERATOR_DIVISION:
                self.currentNumber = self.tempNumber / self.currentNumber;
                break;
            case OPERATOR_EQUAL:
                // self.currentNumber = self.tempNumber; // todo ... problem...
				[self configUIControllerWriteResult:NO writeInLastLbl:NO writeNextLine:YES writeIsOperator:YES];
                break;
            default:
                break;
        }

        self.operator = tag;
		
//		[self configUIControllerWriteResult:YES writeInLastLbl:NO writeNextLine:YES writeIsOperator:YES];
    }
//    // 显示竖式
//    [self.calculatorView drawLblText:[YICalculatorManager signTextOnTag:tag] writeInLastLbl:NO nextLine:YES isOperator:YES];

    return self.currentNumber;
}
// 先按求结果的+ 再按一元操作符
- (double)calCurrentNumberWithUnaryOperator:(int)tag {
	// 上次输入是+-*/ 这次输入是- % <-就算是异常输入
	int lastInput = [[self.inputs lastObject] intValue];
	if ((lastInput >= OPERATOR_ADD && lastInput <= OPERATOR_DIVISION) // 二元操作符
		&& (tag == OPERATOR_DELETE || tag == OPERATOR_PERCENT || tag == OPERATOR_NEGATIVE)) { // 一元操作符
		self.abnormalInput = YES;
		return self.currentNumber;
	}
	
    switch (tag) {
		case OPERATOR_DELETE:{
			NSString *fmtNum = [self formatterNumberNormal:self.currentNumber];
			fmtNum = [fmtNum substringToIndex:fmtNum.length-1];
			self.currentNumber = [fmtNum doubleValue];
			
//			NSString *textNum = [@(self.currentNumber) stringValue];
//			textNum = [textNum substringToIndex:textNum.length-1];;
//			double num = [textNum doubleValue];
//
//			self.currentNumber = num;
			
//            if (self.isDecimal) {
//                self.decimals--;
//                self.currentNumber = (long) (self.currentNumber * pow(10, self.decimals)) * pow(10, (-1) * self.decimals);
//                if (self.decimals <= 0) {
//                    self.isDecimal = NO;
//                }
//            } else {
//                self.currentNumber = (long) (self.currentNumber / 10);
//            }
            break;
		}
        case OPERATOR_CLEAR:
            [self resetDefaultValue];
            break;
        case OPERATOR_PERCENT:
            self.currentNumber *= 0.01;
            /*
             double decimal = self.currentNumber - (long) self.currentNumber;
             if (decimal) {
             NSString *decimalString = [@(self.currentNumber) stringValue];
             self.isDecimal = YES;
             self.decimals = (int) [[[decimalString componentsSeparatedByString:@"."] lastObject] length];
             } else {
             self.isDecimal = NO;
             self.decimals = 0;
             }
             */
            break;
        case OPERATOR_NEGATIVE:
            self.currentNumber *= -1;
            break;
        default:
            break;
    }
	self.writeOp = tag;
	
	[self configUIControllerWriteResult:YES writeInLastLbl:YES writeNextLine:NO writeIsOperator:YES];
	
    return self.currentNumber;
}

- (double)calCurrentNumberWithDot:(int)tag {
    _isDecimal = YES;

    return self.currentNumber;
}

- (double)calCurrentNumberWithTag:(int)tag {

    return self.currentNumber;
}

+ (void)checkRegularExpression {
    NSString *checkString = @"1.234000";
    // 1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
    NSString *pattern = @"([1-9]\\d*)\\.?(\\d*?)(0*$)";
    // 1.1将正则表达式设置为OC规则
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 2.利用规则测试字符串获取匹配结果
    NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
    NSLog(@"%ld", results.count);
    /*
     分析结果：
     从checkingString上分析为数字的字符为 5
     所以可以得出一个结论，正则表达式的作用就是把多个字符串杂糅到一个表达式中
     */
}

- (void)configUIControllerWriteResult:(BOOL)isResult  // 普通的显示当前值 or 有结果的值
					   writeInLastLbl:(BOOL)last
						writeNextLine:(BOOL)next
					  writeIsOperator:(BOOL)isOp {
	self.writeResult = isResult;
	self.writeInLastLbl = last;
	self.writeNextLine = next;
	self.writeIsOperator = isOp;
}


+ (NSString *)signTextOnTag:(int)tag {
    NSString *text = @"";
    switch (tag) {
        case OPERATOR_DELETE:
            text = @"(<-)";
            break;
        case OPERATOR_CLEAR:
            text = @"(AC)";
            break;
        case OPERATOR_PERCENT:
            text = @"(%)";
            break;
        case OPERATOR_NEGATIVE:
            text = @"(-)";
            break;
        case OPERATOR_ADD:
            text = @"+";
            break;
        case OPERATOR_MINUS:
            text = @"-";
            break;
        case OPERATOR_MULTIPLE:
            text = @"×";
            break;
        case OPERATOR_DIVISION:
            text = @"÷";
            break;
        case OPERATOR_EQUAL:
            text = @"=";
            break;
        default:
            text = @"ERROR";
            break;
    }
    return text;
}

- (NSString *)formatterNumber:(double)number {
	NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
	[nf setNumberStyle:NSNumberFormatterDecimalStyle];
	[nf setMaximumFractionDigits:kCalculatorManager.maxLengthDecimal];
	[nf setMaximumIntegerDigits:kCalculatorManager.maxLengthNumber];
	NSString *numberText = [nf stringFromNumber:@(number)];
	return numberText;
}

- (NSString *)formatterNumberNormal:(double)number {
	NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
	[nf setNumberStyle:NSNumberFormatterNoStyle];
	[nf setMaximumFractionDigits:kCalculatorManager.maxLengthDecimal];
	[nf setMaximumIntegerDigits:kCalculatorManager.maxLengthNumber];
	NSString *numberText = [nf stringFromNumber:@(number)];
	return numberText;
}


@end


