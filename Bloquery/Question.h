//
//  Question.h
//  Bloquery
//
//  Created by Sameer Totey on 11/21/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Question : NSObject
- (instancetype)initWithParseObject:(PFObject *)question;

@property (nonatomic, strong)NSString *objectId;
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userId;

- (void)saveQuestion;


@end
