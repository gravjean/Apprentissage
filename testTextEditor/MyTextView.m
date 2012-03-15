//
//  MyTextView.m
//  testTextEditor
//
//  Created by  on 12-03-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(setStrong:)) {
        return YES;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (void) setStrong:(id)sender
{
    NSMutableString *aModifier = [self.text mutableCopy];
    
    NSRange rangeActuel = [self selectedRange];
    
    if (rangeActuel.location != NSNotFound) 
    {
        NSString *selection = [aModifier substringWithRange:rangeActuel];
        NSString *newStr = [NSString stringWithFormat:@"<strong>%@</strong>",selection];
        
        [aModifier replaceCharactersInRange:rangeActuel withString:newStr];
        
        self.text = aModifier;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
