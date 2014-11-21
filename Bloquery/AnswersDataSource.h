//
//  AnswersDataSouce.h
//  Bloquery
//
//  Created by Sameer Totey on 11/18/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ParseDataSource.h"

@interface AnswersDataSource : ParseDataSource

@property (nonatomic, strong, readonly) NSArray *answers;

extern NSString *const AnswersLoadingFinishedNotification;

+ (instancetype)sharedInstanceFor:(NSString *)className;

- (void)reloadAnswers;
@end
