//
//  UIAlertView+Additional.m
//  SAMCategory
//
//  Created by MilanPanchal on 09/09/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertView+Additional.h"


@interface SAMAlertWrapper : NSObject

@property (copy) void(^completionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@end

@implementation SAMAlertWrapper

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completionBlock)
        self.completionBlock(alertView, buttonIndex);
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
    // Just simulate a cancel button click
    if (self.completionBlock)
        self.completionBlock(alertView, alertView.cancelButtonIndex);
}

@end

static const char kSAMAlertWrapper;

@implementation UIAlertView (Additional)

#pragma mark - Class Public

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion {
    SAMAlertWrapper *alertWrapper = [[SAMAlertWrapper alloc] init];
    alertWrapper.completionBlock = completion;
    self.delegate = alertWrapper;
    
    // Set the wrapper as an associated object
    objc_setAssociatedObject(self, &kSAMAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Show the alert as normal
    [self show];
}


+ (void)showAlertViewWithTitle:(NSString*)title andMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                             otherButtonTitles:nil];
    
    
    [alertView show];
}

//TODO: Need to work on varargs with complition handler
/*
+ (void)showAlertWithTitle:(NSString*)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:cancelButtonTitle
                                             otherButtonTitles:otherButtonTitles,nil];
    
    
    SAMAlertWrapper *alertWrapper = [[SAMAlertWrapper alloc] init];
//    alertWrapper.completionBlock = completion;
    alertView.delegate = alertWrapper;
    
    // Set the wrapper as an associated object
    objc_setAssociatedObject(alertView, &kSAMAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [alertView show];
}
*/

+ (void)showAlertViewWithTitle:(NSString*)title{
    
    [self showAlertViewWithTitle:title andMessage:nil];
}


+ (void)showAlertViewWithError:(NSError*)error{

    [self showAlertViewWithTitle:error.localizedDescription andMessage:nil];
    
}


+ (void)showNoNetworkAlertOnWindow {
    
    //    [UIAlertView showAlertViewWithTitle:@"Error" andMessage:@"Internet connection appears to be offline. Please check your settings and try again."];
    [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"Error", nil)
                             andMessage:NSLocalizedString(@"No network. Please try after some time.", nil)];
    
}


@end
