//
//  QuestionTableViewCell.m
//  Bloquery
//
//  Created by Sameer Totey on 11/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "QuestionTableViewCell.h"

@interface QuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeightConstraint;

@end

@implementation QuestionTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.question removeObserver:self forKeyPath:@"Question"];
}

- (void)dealloc {
    [self.question removeObserver:self forKeyPath:@"Question"];
}

- (void)setQuestion:(Question *)question {
    _question = question;
    NSDate *theDate = self.question.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm a"];

    self.timeLabel.text = [formatter stringFromDate:theDate];
    self.questionTextView.text = _question.text;
    [self.userNameButton setTitle:self.question.userName forState:UIControlStateNormal];
    [self.question addObserver:self forKeyPath:@"Question" options:0 context:nil];
}

- (NSDictionary *)getTextAttributes {
    NSMutableParagraphStyle *mutableParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrahStyle.headIndent = 20.0;
    mutableParagrahStyle.firstLineHeadIndent = 20.0;
    mutableParagrahStyle.tailIndent = -20.0;
    mutableParagrahStyle.paragraphSpacingBefore = 5;
    NSParagraphStyle *paragraphStyle = mutableParagrahStyle;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSDictionary *textAttributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName: paragraphStyle};
    return textAttributes;
}

- (NSAttributedString *)timeString {
    NSDate *theDate = self.question.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm a"];
    NSString *baseString = [formatter stringFromDate:theDate];
    NSDictionary *textAttributes = [self getTextAttributes];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return mutableString;
}

- (NSAttributedString *)userNameString {
    NSString *baseString = self.question.userName;
    NSDictionary *textAttributes = [self getTextAttributes];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return mutableString;
}

- (NSAttributedString *)questionText {
    NSString *baseString = self.question.text;
    NSDictionary *textAttributes = [self getTextAttributes];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return mutableString;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.question && [keyPath isEqualToString:@"Question"]) {
        [self.delegate questionRefreshedFor:self];
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
    CGFloat halfSize = CGRectGetWidth(self.contentView.bounds) / 2 - 10;
    CGSize maxLabelSize = CGSizeMake(halfSize, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSDictionary *textAttributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName: paragraphStyle};
    NSString *userName = self.question.userName;
    NSLog(@"username %@", userName);
    CGRect usernameBounds = [userName boundingRectWithSize:maxLabelSize options:options attributes:textAttributes context:ctx];
    
    CGRect timeBounds = [self.timeLabel.text boundingRectWithSize:maxLabelSize options:options attributes:textAttributes context:ctx];
    
    CGSize maxTextSize = CGSizeMake(halfSize * 2, MAXFLOAT);
    CGRect textBounds = [self.questionTextView.text boundingRectWithSize:maxTextSize options:options attributes:textAttributes context:ctx];
    
    
    NSLog(@"Constraints are %f %f %f %f %f %f", usernameBounds.size.width, usernameBounds.size.height, timeBounds.size.width,  timeBounds.size.height, textBounds.size.width, textBounds.size.height);
    self.userNameButtonHeightConstraint.constant = usernameBounds.size.height;
    self.timeLabelHeightConstraint.constant = usernameBounds.size.height;
    self.questionTextViewHeightConstraint.constant = textBounds.size.height;
    
}

- (void)updateConstraints {
    NSLog(@"updateConstraints");
    [super updateConstraints];
}

@end
