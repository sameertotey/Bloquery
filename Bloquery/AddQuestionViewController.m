//
//  AddQuestionViewController.m
//  Bloquery
//
//  Created by Sameer Totey on 11/16/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "AddQuestionViewController.h"
#import <Parse/Parse.h>

@interface AddQuestionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *questionTextField;

@end

@implementation AddQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add a Question";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    // now save the question
    PFObject *question = [PFObject objectWithClassName:@"Questions"];
    question[@"text"] = textField.text;
    question[@"user"] = [PFUser currentUser];
    [question saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
