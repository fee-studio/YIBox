//
//  UIButton+UI.m
//  BaoBaoJi
//
//  Created by efeng on 15/12/26.
//  Copyright © 2015年 buerguo. All rights reserved.
//

#import "UIButton+UI.h"

@implementation UIButton (UI)

- (void)orangeStyle {
	[self setBackgroundColor:[UIColor cantaloupeColor]];
	[self cornerStyle];
	[self setTitleColor:kAppWhiteColor forState:UIControlStateNormal];
}

- (void)greenStyle {
	[self setBackgroundColor:[UIColor grassColor]];
	[self cornerStyle];
	[self setTitleColor:kAppWhiteColor forState:UIControlStateNormal];
}



@end
