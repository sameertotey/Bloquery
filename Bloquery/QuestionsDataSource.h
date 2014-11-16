//
//  QuestionsDataSource.h
//  Bloquery
//
//  Created by Sameer Totey on 11/14/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionsDataSource : NSObject

@property (nonatomic, strong, readonly) NSArray *questions;
@property (nonatomic, strong) NSString *className;

extern NSString *const QuestionsLoadingFinishedNotification;


+ (instancetype)sharedInstance;

- (void)reloadQuestions;
@end
