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
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewHeightContraint;
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;
@property (strong, nonatomic) UIImage *userImage;
@property (assign, nonatomic) BOOL isImageUpdated;
@property (strong, nonatomic) UIBarButtonItem *logoff;
@end

@implementation UserProfileViewController

#define USER_IMAGE_WIDTH 200
#define USER_IMAGE_HEIGHT 200

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];

    self.userNameLabel.text = self.user.username;
    self.userDescriptionTextView.text = self.user[@"description"];
    self.emailAddressLabel.text = self.user[@"email"];
    [self setImage];
    
    if (self.user != [PFUser currentUser]) {
        self.view.userInteractionEnabled = NO;
        self.navigationItem.rightBarButtonItems = @[];
        self.addPictureButton.hidden = YES;
    } else {
        self.logoff = [[UIBarButtonItem alloc] initWithTitle:@"Logoff" style:UIBarButtonItemStylePlain target:self action:@selector(logoffUser)];
        self.navigationItem.rightBarButtonItems = @[self.logoff, self.saveButton];
    }
}

- (void)logoffUser {
    [PFUser logOut];
}

- (void)setImage {
    self.isImageUpdated = NO;
    self.userImageViewHeightContraint.constant = USER_IMAGE_HEIGHT;
    self.userImageViewWidthConstraint.constant = USER_IMAGE_WIDTH;
    if (self.user[@"imageFile"]) {
        PFFile *imageFile = self.user[@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.userImage = [UIImage imageWithData:imageData];
                self.userImageView.image = self.userImage;
                [self.addPictureButton setTitle:@"Replace" forState:UIControlStateNormal];
            }
        }];
    } else {
        [self.addPictureButton setTitle:@"Add" forState:UIControlStateNormal];
    }
}

- (IBAction)imageButtonTouched:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [self showCamera];
    else {
        NSLog(@"The device does not have a camera");
    }
}

- (void)showCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)saveUserProfile:(id)sender {
    if ([self.user isDirty]) {
        if (self.isImageUpdated) {
            [self.user[@"imageFile"] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                        [self.user saveInBackground];
                }
            }];
        } else {
            [self.user saveInBackground];
        }
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
    self.userDescriptionTextViewHeight.constant = userDescriptionTextViewSize.height + 20;
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


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.addPictureButton setTitle:@"Replace" forState:UIControlStateNormal];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(USER_IMAGE_WIDTH, USER_IMAGE_HEIGHT));
    [chosenImage drawInRect: CGRectMake(0, 0, USER_IMAGE_WIDTH, USER_IMAGE_HEIGHT)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.userImageView.image = smallImage;
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.5f);

    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    self.user[@"imageFile"] = imageFile;
    self.isImageUpdated = YES;

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
