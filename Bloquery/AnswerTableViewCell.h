//
//  AnswerTableViewCell.h
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameAndTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameAndTimeLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *answerDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerDescriptionLabelHeightConstraint;
@property (strong, nonatomic) Answer *answer;
@property (strong, nonatomic) NSIndexPath *path;

extern NSString *const AnswerRefreshedNotification;

@end
