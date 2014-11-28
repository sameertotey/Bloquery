//
//  UserNameAndDateTimeView.m
//  Bloquery
//
//  Created by Sameer Totey on 11/24/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "UserNameAndDateTimeView.h"

@interface UserNameAndDateTimeView ()
@property (nonatomic, strong)NSLayoutConstraint *userNameButtonHeightConstraint;
@property (nonatomic, strong)NSLayoutConstraint *dateAndTimeLabelHeightConstraint;
@end

@implementation UserNameAndDateTimeView


- (void)awakeFromNib {
    [self initialize];
}

- (instancetype)init {
    self  = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.dateAndTimeLabel = [[UILabel alloc] init];
    self.dateAndTimeLabel.numberOfLines = 0;
    self.dateAndTimeLabel.backgroundColor = [UIColor clearColor];
    [self.dateAndTimeLabel setLineBreakMode:NSLineBreakByCharWrapping];
    
    self.userNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.userNameButton addTarget:self action:@selector(userNameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.userNameButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    
    for (UIView *view in @[self.dateAndTimeLabel, self.userNameButton]) {
        [self addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self createConstraints];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"This is the drawing of the user name and time view");
}
*/

- (void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_dateAndTimeLabel, _userNameButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_userNameButton]-[_dateAndTimeLabel(>=_userNameButton)]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_userNameButton]" options:kNilOptions metrics:nil views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dateAndTimeLabel]" options:kNilOptions metrics:nil views:viewDictionary]];
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    [self.userNameButton setTitle:userName forState:UIControlStateNormal];
}

- (void)setDateAndTime:(NSDate *)dateAndTime {
    _dateAndTime = dateAndTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm a"];
    NSString *timeString = [formatter stringFromDate:dateAndTime];
    self.dateAndTimeLabel.Text = timeString;
    self.dateAndTimeLabel.attributedText = [self applyBasicStringAttributesTo:timeString];
}

- (NSParagraphStyle *)getParagraphStyle {
    NSMutableParagraphStyle *mutableParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrahStyle.headIndent = 20.0;
    mutableParagrahStyle.firstLineHeadIndent = 20.0;
    mutableParagrahStyle.tailIndent = -20.0;
    mutableParagrahStyle.paragraphSpacingBefore = 5;
    NSParagraphStyle *paragraphStyle = mutableParagrahStyle;
    return paragraphStyle;
}

- (NSAttributedString *)applyBasicStringAttributesTo:(NSString *)baseString {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName :[self getParagraphStyle]}];
    return mutableAttributedString;
};

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, MAX(CGRectGetHeight(self.userNameButton.frame), CGRectGetHeight(self.dateAndTimeLabel.frame)));
}

/*

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"inside the layout subviews of usernameanddatetimeview with username %@ at %@", self.userNameButton, self.dateAndTimeLabel);
//    UIFont *font = [UIFont systemFontOfSize:17];
//    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
//    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
//    
//    CGSize userButtonMaxSize = CGSizeMake(CGRectGetWidth(self.bounds)/2, CGFLOAT_MAX);
//    CGRect usernameBounds = [self.userNameButton.titleLabel.text boundingRectWithSize:userButtonMaxSize options:options attributes:@{NSFontAttributeName : font} context:ctx];
//
//    
//    CGSize usernameButtonSize = [self.userNameButton sizeThatFits:userButtonMaxSize];
//    [self.userNameButton.titleLabel.text drawInRect:usernameBounds withAttributes:@{NSFontAttributeName : font}];
//    CGSize maxSize = CGSizeMake(MAX(CGRectGetWidth(self.bounds) / 2, (CGRectGetWidth(self.bounds) - usernameButtonSize.width)), CGFLOAT_MAX);
//    CGSize dateAndTimeLabelSize = [self.dateAndTimeLabel sizeThatFits:maxSize];
//    
//    self.userNameButtonHeightConstraint.constant = usernameButtonSize.height + 20;
//    self.dateAndTimeLabelHeightConstraint.constant = dateAndTimeLabelSize.height + 20;
    
//    [self updateConstraints];

//
//
//    
//    CGSize maxLabelSize = CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT);
//    CGRect usernameBounds = [self.userNameButton.titleLabel.text boundingRectWithSize:maxLabelSize options:options attributes:@{NSFontAttributeName : font} context:ctx];
//    
    //    self.userNameAndTimeLabelHeightConstraint.constant = usernameBounds.size.height;
    //    [self.userNameAndTimeLabel.text drawInRect:usernameBounds withAttributes:@{NSFontAttributeName : font}];
    //
    //    CGSize maxTextSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) - 40, MAXFLOAT);
    //    font = [UIFont systemFontOfSize:16];
    //    CGRect textBounds = [self.answerDescriptionLabel.text boundingRectWithSize:maxTextSize options:options attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName: paragraphStyle} context:ctx];
    //    self.answerDescriptionLabelHeightConstraint.constant = textBounds.size.height;
    //    [self.answerDescriptionLabel.text drawInRect:textBounds withAttributes:@{NSFontAttributeName: font, N
}
*/

- (void)userNameButtonPressed:(UIButton *)sender {
    NSLog(@"userNameButtonPressed %@", sender.titleLabel.text);
    [self.delegate userNameButtonPressedFor:sender.titleLabel.text];
}

@end
