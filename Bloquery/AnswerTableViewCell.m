//
//  AnswerTableViewCell.m
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AnswerTableViewCell.h"


@implementation AnswerTableViewCell

NSString *const AnswerRefreshedNotification = @"AnswerRefreshedNotification";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.answer removeObserver:self forKeyPath:@"Answer"];
}

- (void)dealloc {
    [self.answer removeObserver:self forKeyPath:@"Answer"];
}

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    
    NSDate *theDate = answer.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm a"];
    NSString *timeString = [formatter stringFromDate:theDate];
    
    self.userNameAndTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", answer.userName, timeString];
    self.answerDescriptionLabel.text = answer.text;
    
    [self.answer addObserver:self forKeyPath:@"Answer" options:0 context:nil];
    [self.contentView setNeedsLayout];
    [self.contentView setNeedsDisplay];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.answer && [keyPath isEqualToString:@"Answer"]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:AnswerRefreshedNotification object:self.path];

    }
}


- (void) layoutSubviews {
    [super layoutSubviews];
    // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and set the appropriate constraints

    NSMutableParagraphStyle *mutableParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrahStyle.headIndent = 20.0;
    mutableParagrahStyle.firstLineHeadIndent = 20.0;
    mutableParagrahStyle.tailIndent = -20.0;
    mutableParagrahStyle.paragraphSpacingBefore = 5;
    NSParagraphStyle *paragraphStyle = mutableParagrahStyle;
    
    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
    CGSize maxLabelSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) - 40, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGRect usernameBounds = [self.userNameAndTimeLabel.text boundingRectWithSize:maxLabelSize options:options attributes:@{NSFontAttributeName : font} context:ctx];

    self.userNameAndTimeLabelHeightConstraint.constant = usernameBounds.size.height;
    [self.userNameAndTimeLabel.text drawInRect:usernameBounds withAttributes:@{NSFontAttributeName : font}];
    
    CGSize maxTextSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) - 40, MAXFLOAT);
    font = [UIFont systemFontOfSize:16];
    CGRect textBounds = [self.answerDescriptionLabel.text boundingRectWithSize:maxTextSize options:options attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName: paragraphStyle} context:ctx];
    self.answerDescriptionLabelHeightConstraint.constant = textBounds.size.height;
    [self.answerDescriptionLabel.text drawInRect:textBounds withAttributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    
}

@end
