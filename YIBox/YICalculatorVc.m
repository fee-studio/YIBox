//
// Created by efeng on 16/3/11.
// Copyright (c) 2016 buerguo. All rights reserved.
//

#import "YICalculatorVc.h"
#import "YICalculatorView.h"
#import "UINavigationBar+Awesome.h"
#import "YICalculatorManager.h"

@interface YICalculatorVc () <YICalculatorViewDelegate>
{
	YICalculatorView *calculatorView;
	YICalculatorManager *calManager;
}

@end

@implementation YICalculatorVc {

}

- (instancetype)init {
	self = [super init];
	if (self) {
		calManager = [YICalculatorManager sharedManager];
	}

	return self;
}


//- (void)loadView {
//	self.view = [UIView new];
//	calculatorView = [[YICalculatorView alloc] init];
//    calculatorView.delegate = self;
//    [self.view addSubview:calculatorView];
//	UIEdgeInsets padding = UIEdgeInsetsMake(64, 0, 0, 0);
//	[calculatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(calculatorView.superview).with.insets(padding);
//	}];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//	calManager.calculatorView = calculatorView;
//	self.edgesForExtendedLayout = UIRectEdgeAll;
	
	calculatorView = [[YICalculatorView alloc] init];
	calculatorView.delegate = self;
	[self.view addSubview:calculatorView];
	UIEdgeInsets padding = UIEdgeInsetsMake(64, 0, 0, 0);
	[calculatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(calculatorView.superview).with.insets(padding);
	}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
}

#pragma mark - YICalculatorViewDelegate

- (void)clickButtonTag:(int)tag {
	// 每次输入 默认都是正常的输入
	kCalculatorManager.abnormalInput = NO;
	
	if (tag >= 3001 && tag <= 3005) {
		// 加减乘除等于号(二元运算符)
		[self binaryOperatorPressed:tag];
	} else if (tag >= 2001 && tag <= 2004) {
		// 一元运算符
		[self unaryOperatorPressed:tag];
	} else if (tag >= 1000 && tag <= 1010) {
		// 数字
		[self numberPressed:tag];
	}
	
	if (kCalculatorManager.abnormalInput == NO) {
		// 记入输入队列
		[kCalculatorManager inputObject:tag];
		
		// 显示竖式
		[calculatorView drawLblCurNumberText:kCalculatorManager.currentNumber
									operator:kCalculatorManager.operator
							  writeInLastLbl:kCalculatorManager.writeInLastLbl
									nextLine:kCalculatorManager.writeNextLine
								  isOperator:kCalculatorManager.writeIsOperator
									isResult:kCalculatorManager.writeResult];
		
		kCalculatorManager.writeOp = OPERATOR_NULL;
	}
}

#pragma mark - 不同类型的按钮

- (void)numberPressed:(int)tag {
    int digit = tag - 1000;
    // 计算当前的值
    [kCalculatorManager calCurrentNumberWithDigit:digit];
	[calculatorView setDisplayLblText:kCalculatorManager.currentNumber];
}

- (void)binaryOperatorPressed:(int)tag {
	[kCalculatorManager calCurrentNumberWithBinaryOperator:tag];
	[calculatorView setDisplayLblText:kCalculatorManager.currentNumber];
}

- (void)unaryOperatorPressed:(int)tag {
	[kCalculatorManager calCurrentNumberWithUnaryOperator:tag];
	[calculatorView setDisplayLblText:kCalculatorManager.currentNumber];
}



@end