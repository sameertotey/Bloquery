//
//  QuestionsDataSource.m
//  Bloquery
//
//  Created by Sameer Totey on 11/14/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "QuestionsDataSource.h"
#import <Parse/Parse.h>

@interface QuestionsDataSource () {
    NSMutableArray *_questions;
}

@property (nonatomic, strong, readwrite) NSArray *questions;
@end

@implementation QuestionsDataSource

NSString *const QuestionsLoadingFinishedNotification = @"QuestionsLoadedFinishedNotification";


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.className = @"Questions";
        [self queryLatestQuestions];
      }
    return self;
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
            NSLog(@"Successfully retrieved %lu chats from cache.", (unsigned long)objects.count);
            //                [_questions removeAllObjects];
            _questions = [NSMutableArray array];
            [_questions addObjectsFromArray:objects];
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
