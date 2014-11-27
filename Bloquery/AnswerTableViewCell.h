//
//  AnswerTableViewCell.h
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@class AnswerTableViewCell;

@protocol AnswerTableViewCellDelegate <NSObject>

- (void)answerRefreshedFor:(AnswerTableViewCell *)cell;
- (void)likeButtonPressedFor:(Answer *)answer;

@end

@interface AnswerTableViewCell : UITableViewCell
@property (strong, nonatomic) Answer *answer;
@property (strong, nonatomic) NSIndexPath *path;
@property (weak, nonatomic) id<AnswerTableViewCellDelegate> delegate;
@end
