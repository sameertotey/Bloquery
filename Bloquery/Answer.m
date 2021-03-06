//
//  Answer.m
//  Bloquery
//
//  Created by Sameer Totey on 11/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"Answer object instantiated without assigning a Parse object");
    }
    return self;
}

- (instancetype)initWithParseObject:(PFObject *)answer {
    self = [super init];
    if (self) {
        self.objectId = answer.objectId;
        self.text = answer[@"text"];
        self.date = answer[@"date"];
        PFUser *user = answer[@"user"];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                [self willChangeValueForKey:@"Answer"];
                self.userName = object[@"username"];
                self.userId = object[@"objectId"];
                if ([object isKindOfClass:[PFUser class]]) {
                    self.user = (PFUser *)object;
                }
                [self didChangeValueForKey:@"Answer"];
            }
        }];
        PFQuery *likesCount = [PFQuery queryWithClassName:@"Likes"];
        [likesCount whereKey:@"answer" equalTo:[PFObject objectWithoutDataWithClassName:@"Answers" objectId:self.objectId]];
        [likesCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                [self willChangeValueForKey:@"Answer"];
                self.likes = number;
                [self didChangeValueForKey:@"Answer"];
            }
        }];
    }
    return self;
}

- (void)saveAnswer {
    PFObject *newAnswer = [PFObject objectWithClassName:@"Answers"];
    newAnswer[@"text"] = self.text;
    newAnswer[@"question"] = [PFObject objectWithoutDataWithClassName:@"Question" objectId:self.questionId];
    newAnswer[@"user"] = [PFUser currentUser];
    newAnswer[@"date"] = [NSDate date];
    [newAnswer saveInBackground];
}

- (void)liked {
    PFObject *newLike = [PFObject objectWithClassName:@"Likes"];
    newLike[@"answer"] = [PFObject objectWithoutDataWithClassName:@"Answers" objectId:self.objectId];
    newLike[@"user"] = [PFUser currentUser];
    newLike[@"date"] = [NSDate date];
    [newLike saveInBackground];
    [self willChangeValueForKey:@"Answer"];
    self.likes++;
    [self didChangeValueForKey:@"Answer"];
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

- (NSString *)questionId {
    if (!_questionId) {
        _questionId = [[NSString alloc] init];
    }
    return _questionId;
}

@end
