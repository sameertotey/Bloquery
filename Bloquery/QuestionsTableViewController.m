//
//  QuestionsTableViewController.m
//  Bloquery
//
//  Created by Sameer Totey on 11/14/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "QuestionsTableViewController.h"
#import "QuestionsDataSource.h"
#import "AddQuestionViewController.h"
#import "QuestionDetailViewController.h"
#import "Question.h"
#import "QuestionTableViewCell.h"
#import "UserNameAndDateTimeView.h"

@interface QuestionsTableViewController () <QuestionTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *questionsTableView;
@end

@implementation QuestionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (![PFUser currentUser]) { // No user logged in
        [self login];
        self.navigationItem.leftBarButtonItem.title = @"Logoff";
     }
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestQuestions)
                  forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionsLoaded:) name:QuestionsLoadingFinishedNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [self getLatestQuestions];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// toggle the Login and Logoff functons on pressing the left bar button of the root controller
- (IBAction)loginLogoff:(UIBarButtonItem *)sender {
    if ([PFUser currentUser]) {
        [PFUser logOut];
        sender.title = @"Login";
    } else {
        [self login];
        sender.title = @"Logoff";
    }
}

- (void)QuestionsLoaded:(NSNotification *)notification {
    [self.questionsTableView reloadData];
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (void)getLatestQuestions {
    [[QuestionsDataSource sharedInstanceFor:@"Questions"] reloadQuestions];
}

- (void)login {
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // add the facebook field to the login controller
    [logInViewController setFields: PFLogInFieldsDefault |  PFLogInFieldsFacebook ];
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
   
}

// return all the questions from the questions data source
- (NSArray *)questions {
    return [QuestionsDataSource sharedInstanceFor:@"Questions"].questions;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self questions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *questionIdentifier = @"questionCell";
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:questionIdentifier forIndexPath:indexPath];
   
    // Configure the cell...
    cell.question = [self questions][indexPath.row];
    cell.path = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    Question *question = [self questions][indexPath.row];
    UserNameAndDateTimeView *userNameAndDate = [[UserNameAndDateTimeView alloc] init];
    userNameAndDate.dateAndTime = question.date;
    userNameAndDate.userName = question.userName;
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 40, 200);
    userNameAndDate.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);
    [userNameAndDate setNeedsLayout];
    [userNameAndDate layoutIfNeeded];
    CGSize userNameAndDateTimeViewSize = [userNameAndDate sizeThatFits:maxSize];
    CGFloat cellHeight = userNameAndDateTimeViewSize.height;

    
    NSMutableParagraphStyle *mutableParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrahStyle.headIndent = 20.0;
    mutableParagrahStyle.firstLineHeadIndent = 20.0;
    mutableParagrahStyle.tailIndent = -20.0;
    mutableParagrahStyle.paragraphSpacingBefore = 5;
    NSParagraphStyle *paragraphStyle = mutableParagrahStyle;
    
    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSDictionary *textAttributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName: paragraphStyle};

    
    CGRect textBounds = [question.text boundingRectWithSize:maxSize options:options attributes:textAttributes context:ctx];
    
    return cellHeight + textBounds.size.height + 30;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath: %@", indexPath);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:accessoryButtonTappedForTRowWithIndexPath:%@", indexPath);
}

#pragma mark - PFLoginViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    self.navigationItem.leftBarButtonItem.title = @"Login";
    NSLog(@"Cancelled the login view");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"QuestionDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[QuestionDetailViewController class]]) {
            QuestionDetailViewController *qdvc = (QuestionDetailViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[QuestionTableViewCell class]]) {
                QuestionTableViewCell *sourceCell = (QuestionTableViewCell *)sender;
                qdvc.question = sourceCell.question;
            }
        }
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}


#pragma mark - QuestionTableViewCellDelegate

- (void)questionRefreshedFor:(QuestionTableViewCell *)cell {
//    [self.tableView reloadRowsAtIndexPaths:@[cell.path] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

@end
