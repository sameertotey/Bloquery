//
//  QuestionsDataSource.m
//  Bloquery
//
//  Created by Sameer Totey on 11/14/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "QuestionsDataSource.h"
#import <Parse/Parse.h>
#import "Question.h"

@interface QuestionsDataSource () {
    NSMutableArray *_questions;
}

@property (nonatomic, strong, readwrite) NSArray *questions;
@end

@implementation QuestionsDataSource

NSString *const QuestionsLoadingFinishedNotification = @"QuestionsLoadedFinishedNotification";

+ (instancetype)sharedInstanceFor:(NSString *)className {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithClassName:className];
        [sharedInstance reload];
    });
    return sharedInstance;
}

- (void)reload {
    [super reload];
    [self reloadQuestions];
}

- (void)reloadQuestions {
    [self queryLatestQuestions];
}

- (void)queryLatestQuestions {
    PFQuery *questionsQuery = [PFQuery queryWithClassName:self.className];
    questionsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [questionsQuery orderByAscending:@"createdAt"];
    NSLog(@"Trying to retrieve from cache");
    [questionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded
            NSLog(@"Successfully retrieved %lu questions from cache.", (unsigned long)objects.count);
            //                [_questions removeAllObjects];
            _questions = [NSMutableArray array];
            for (PFObject *questionObject in objects) {
                Question *question = [[Question alloc]initWithParseObject:questionObject];
                [_questions addObject:question];
            }
            self.questions = _questions;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:QuestionsLoadingFinishedNotification object:self];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
