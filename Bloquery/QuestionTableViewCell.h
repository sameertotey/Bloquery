//
//  QuestionTableViewCell.h
//  Bloquery
//
//  Created by Sameer Totey on 11/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@class QuestionTableViewCell;

@protocol QuestionTableViewCellDelegate <NSObject>
- (void)questionRefreshedFor:(QuestionTableViewCell *)cell;

@end

@interface QuestionTableViewCell : UITableViewCell
@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) NSIndexPath *path;
@property (weak, nonatomic) id<QuestionTableViewCellDelegate> delegate;


@end