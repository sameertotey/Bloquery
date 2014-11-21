//
//  QuestionsDataSource.h
//  Bloquery
//
//  Created by Sameer Totey on 11/14/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDataSource.h"

@interface QuestionsDataSource : ParseDataSource

@property (nonatomic, strong, readonly) NSArray *questions;

+ (instancetype)sharedInstanceFor:(NSString *)className;

extern NSString *const QuestionsLoadingFinishedNotification;

- (void)reloadQuestions;
@end
