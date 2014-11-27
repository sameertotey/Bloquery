//
//  QuestionTableViewCell.m
//  Bloquery
//
//  Created by Sameer Totey on 11/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "UserNameAndDateTimeView.h"

@interface QuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UserNameAndDateTimeView *userNameAndDateTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameAndDateTimeHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;


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
  
    self.userNameAndDateTimeView.userName = question.userName;
    self.userNameAndDateTimeView.dateAndTime = question.date;
    self.questionTextLabel.text = question.text;
    
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
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds), MAXFLOAT);
    
    CGSize userNameAndDateTimeSize = [self.userNameAndDateTimeView sizeThatFits:maxSize];
    self.userNameAndDateTimeHeightConstraint.constant = userNameAndDateTimeSize.height;
    
    [self updateConstraints];
    [self setNeedsDisplay];
}

@end
