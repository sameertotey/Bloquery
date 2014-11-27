//
//  Answer.h
//  Bloquery
//
//  Created by Sameer Totey on 11/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <Parse/Parse.h>

@interface Answer : NSObject
- (instancetype)initWithParseObject:(PFObject *)answer;

@property (nonatomic, strong)NSString *objectId;
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *questionId;
@property (nonatomic, assign)NSUInteger likes;
- (void)saveAnswer;
- (void)liked;

@end
