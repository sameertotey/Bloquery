//
//  ParseDataSource.h
//  Bloquery
//
//  Created by Sameer Totey on 11/18/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseDataSource : NSObject

@property (nonatomic, strong) NSString *className;


- (void)reload;

@end
