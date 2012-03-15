//
//  ViewControllerUtilitaire.h
//  testTextEditor
//
//  Created by  on 12-03-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTextView;

@interface ViewControllerUtilitaire : UIViewController
{
    MyTextView *textView;
}

@property (retain, nonatomic) MyTextView *textView;

- (IBAction)clickHide:(UIButton *)sender;

@end
