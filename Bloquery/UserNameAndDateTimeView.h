//
//  UserNameAndDateTimeView.h
//  Bloquery
//
//  Created by Sameer Totey on 11/24/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserNameAndDateTimeViewDelegate <NSObject>

- (void)userNameButtonPressedFor:(NSString *)userName;

@end

@interface UserNameAndDateTimeView : UIView
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSDate *dateAndTime;
@property (nonatomic, strong)IBOutlet UIButton *userNameButton;
@property (nonatomic, strong)IBOutlet UILabel *dateAndTimeLabel;
@property (nonatomic, weak)id<UserNameAndDateTimeViewDelegate> delegate;
@end