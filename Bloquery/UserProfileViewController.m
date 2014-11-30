//
//  UserProfileViewController.m
//  Bloquery
//
//  Created by Sameer Totey on 11/28/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *userDescriptionTextView;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userDescriptionTextViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];

    self.userNameLabel.text = self.user.username;
    self.userDescriptionTextView.text = self.user[@"description"];
    self.emailAddressLabel.text = self.user[@"email"];
}

- (IBAction)saveUserProfile:(id)sender {
    if ([self.user isDirty]) {
        [self.user saveInBackground];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.userDescriptionTextView.backgroundColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = nil;
    self.user[@"description"] = self.userDescriptionTextView.text;
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)doneEditing {
    [self.userDescriptionTextView resignFirstResponder];
}

- (void)cancelEditing {
    [self.userDescriptionTextView resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.userDescriptionTextView.bounds), CGFLOAT_MAX);
    
    CGSize userDescriptionTextViewSize = [self.userDescriptionTextView sizeThatFits:maxSize];
    self.userDescriptionTextViewHeight.constant = userDescriptionTextViewSize.height;
    [self.userDescriptionTextView scrollRangeToVisible:NSRangeFromString(self.userDescriptionTextView.text)];

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
