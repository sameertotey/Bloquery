//
//  ParseDataSource.m
//  Bloquery
//
//  Created by Sameer Totey on 11/18/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ParseDataSource.h"

@implementation ParseDataSource


- (instancetype) initWithClassName:(NSString *)className {
    self = [super init];
    
    if (self) {
        self.className = className;
        [self reload];
    }
    return self;
}

- (void)reload {
    // override this method in the child classes to get the data from parse
}

@end
