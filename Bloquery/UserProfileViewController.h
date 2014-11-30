//
//  UserProfileViewController.h
//  Bloquery
//
//  Created by Sameer Totey on 11/28/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserProfileViewController : UIViewController
@property (nonatomic, strong)PFUser *user;

@end
