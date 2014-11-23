//
//  AnswersDataSouce.m
//  Bloquery
//
//  Created by Sameer Totey on 11/18/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AnswersDataSource.h"
#import "Answer.h"
#import  <Parse/Parse.h>


@interface AnswersDataSource () {
    NSMutableArray *_answers;
}

@property (nonatomic, strong, readwrite) NSArray *answers;
@end

@implementation AnswersDataSource

NSString *const AnswersLoadingFinishedNotification = @"AnswersLoadedFinishedNotification";


+ (instancetype)sharedInstanceFor:(NSString *)className withQuestionId:(NSString *)questionId {
    static dispatch_once_t once;
    static AnswersDataSource *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithClassName:className];
    });
    sharedInstance.questionId = questionId;
    [sharedInstance reload];
    return sharedInstance;
}

- (void)reload {
    // Call the super reload method just in case there is some implementation in the parent class
    [super reload];
    [self reloadAnswers];
}

- (void)reloadAnswers {
    [self queryLatestAnswers];
}

- (void)queryLatestAnswers {
    PFQuery *answersQuery = [PFQuery queryWithClassName:self.className];
    answersQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [answersQuery orderByAscending:@"createdAt"];
    [answersQuery whereKey:@"question" equalTo:[PFObject objectWithoutDataWithClassName:@"Question" objectId:self.questionId]];
    NSLog(@"Trying to retrieve from cache");
    [answersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded
            NSLog(@"Successfully retrieved %lu chats from cache.", (unsigned long)objects.count);
            //                [_questions removeAllObjects];
            _answers = [NSMutableArray array];
            for (PFObject *answerObject in objects) {
                Answer *answer = [[Answer alloc]initWithParseObject:answerObject];
                [_answers addObject:answer];
            }
            self.answers = _answers;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:AnswersLoadingFinishedNotification object:self];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
