//
//  MyTextFile.h
//  testTextEditor
//
//  Created by  on 12-03-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextFile : NSObject
{
    NSString *text;
}

@property (retain, nonatomic) NSString *text;

+ (MyTextFile *) sharedInstance;

@end
