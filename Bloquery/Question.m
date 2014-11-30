//
//  Question.m
//  Bloquery
//
//  Created by Sameer Totey on 11/21/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "Question.h"

@implementation Question

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"Question object instantiated without assigning a Parse object");
    }
    return self;
}

- (instancetype)initWithParseObject:(PFObject *)question {
    self = [super init];
    if (self) {
        self.objectId = question.objectId;
        self.text = question[@"text"];
        self.date = question[@"date"];
        PFUser *user = question[@"user"];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                [self willChangeValueForKey:@"Question"];
                self.userName = object[@"username"];
                self.userId = object[@"objectId"];
                if ([object isKindOfClass:[PFUser class]]) {
                    self.user = (PFUser *)object;
                }
                [self didChangeValueForKey:@"Question"];
            }
        }];
    }
    return self;
}

- (void)saveQuestion {
    PFObject *newquestion = [PFObject objectWithClassName:@"Questions"];
    newquestion[@"text"] = self.text;
    newquestion[@"user"] = [PFUser currentUser];
    newquestion[@"date"] = [NSDate date];
    [newquestion saveInBackground];
}

- (NSString *)objectId {
    if (!_objectId) {
        _objectId = [[NSString alloc] init];
    }
    return _objectId;
}

- (NSString *)text {
    if (!_text) {
        _text = [[NSString alloc] init];
    }
    return _text;
}

- (NSDate *)date {
    if (!_date) {
        _date = [[NSDate alloc]init];
    }
    return _date;
}

- (NSString *)userName {
    if (!_userName) {
        _userName = [[NSString alloc]init];
    }
    return _userName;
}

- (NSString *)userId {
    if (!_userId) {
        _userId = [[NSString alloc]init];
    }
    return _userId;
}

@end
