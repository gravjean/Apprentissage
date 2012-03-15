//
//  ViewController.h
//  testTextEditor
//
//  Created by  on 12-03-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewControllerUtilitaire;
@class MyTextView;

@interface ViewController : UIViewController <UITextViewDelegate>
{
    ViewControllerUtilitaire *maVueUtilitaire;
    BOOL isKeyboardShow;
}

@property (retain, nonatomic) IBOutlet MyTextView *txtContenu;

- (void) keyboardWillShowOrHide:(NSNotification *) n;

- (CGRect)keyboardRect:(NSNotification *) n;

- (NSTimeInterval)keybordAnimationTimming:(NSNotification *) n;

- (UIViewAnimationCurve) keyboardAnnimationCurve:(NSNotification *) n;

@end
