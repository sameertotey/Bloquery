//
//  QuestionDetailViewController.h
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetailViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *question;
@end
