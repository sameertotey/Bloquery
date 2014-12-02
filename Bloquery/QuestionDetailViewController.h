//
//  QuestionDetailViewController.h
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "UserNameAndDateTimeView.h"
#import "AnswerTableViewCell.h"


@interface QuestionDetailViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UserNameAndDateTimeViewDelegate, UIActionSheetDelegate, AnswerTableViewCellDelegate>
@property (nonatomic, strong) Question *question;
@end
