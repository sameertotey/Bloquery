//
//  AnswerTableViewCell.m
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "UserNameAndDateTimeView.h"

@interface AnswerTableViewCell ()
@property (weak, nonatomic) IBOutlet UserNameAndDateTimeView *userNameAndDateTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameAndDateTimeViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UITextView *answerDescriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerDescriptionTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation AnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.separatorInset = UIEdgeInsetsZero;

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
    
    self.userNameAndDateTimeView.userName = answer.userName;
    self.userNameAndDateTimeView.dateAndTime = answer.date;
    self.likeCountLabel.text = [NSString stringWithFormat:@"Likes:%lu", (unsigned long)answer.likes];
    self.answerDescriptionTextView.Text = answer.text;
//    self.answerDescriptionTextView.textContainer.widthTracksTextView = YES;
//    self.answerDescriptionTextView.textContainer.heightTracksTextView = YES;
//    self.answerDescriptionTextView.textContainerInset = UIEdgeInsetsZero;

    [self.answer addObserver:self forKeyPath:@"Answer" options:0 context:nil];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.answer && [keyPath isEqualToString:@"Answer"]) {
        [self.delegate answerRefreshedFor:self];
    }
}
- (IBAction)likeButtonPressed:(id)sender {
    NSLog(@"Like button pressed");
    [self.delegate likeButtonPressedFor:self.answer];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and set the appropriate constraints
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds), MAXFLOAT);

    CGSize userNameAndDateTimeSize = [self.userNameAndDateTimeView sizeThatFits:maxSize];
    self.userNameAndDateTimeViewHeightConstraint.constant = userNameAndDateTimeSize.height;
    
    CGSize answerDescriptionTextViewSize = [self.answerDescriptionTextView sizeThatFits:maxSize];
    self.answerDescriptionTextViewHeightConstraint.constant = answerDescriptionTextViewSize.height;
    [self updateConstraints];
    [self setNeedsDisplay];
}

@end
