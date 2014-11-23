//
//  QuestionDetailViewController.m
//  Bloquery
//
//  Created by Sameer Totey on 11/17/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import <Parse/Parse.h>
#import "Answer.h"
#import "AnswersDataSource.h"
#import "AnswerTableViewCell.h"

@interface QuestionDetailViewController ()<AnswerTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *answersTableView;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) AnswersDataSource *answerDataSource;
@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userLabel.text = self.question.userName;
    self.questionTextView.attributedText = [self questionString];
    self.answerTextView.delegate = self;
    self.navigationItem.title = @"Question Detail";
    self.navigationItem.leftBarButtonItem.title = @"Back";
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    self.answerDataSource = [AnswersDataSource sharedInstanceFor:@"Answers" withQuestionId:self.question.objectId];
    [self.answerDataSource reload];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answersLoaded:) name:AnswersLoadingFinishedNotification object:nil];
}

- (NSAttributedString *)questionString {
    NSString *basestring = [NSString stringWithFormat:@"%@ asked %@", self.question.userName, self.question.text];
    NSMutableParagraphStyle *mutableParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrahStyle.headIndent = 20.0;
    mutableParagrahStyle.firstLineHeadIndent = 20.0;
    mutableParagrahStyle.tailIndent = -20.0;
    mutableParagrahStyle.paragraphSpacingBefore = 5;
    NSParagraphStyle *paragraphStyle = mutableParagrahStyle;

    NSMutableAttributedString *mutableUsernameAndQuestionString = [[NSMutableAttributedString alloc] initWithString:basestring attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : paragraphStyle}];
    NSRange usernameRange = [basestring rangeOfString:self.question.userName];
    [mutableUsernameAndQuestionString addAttribute:NSFontAttributeName value:[[UIFont fontWithName:@"HelveticaNeue-Bold" size:11] fontWithSize:12] range:usernameRange];
    [mutableUsernameAndQuestionString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.345 green:0.315 blue:0.427 alpha:1] range:usernameRange];
    
    return mutableUsernameAndQuestionString;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize boundingRect = CGSizeMake(CGRectGetWidth(self.questionTextView.frame), MAXFLOAT);
    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect textRect = [self.questionTextView.text boundingRectWithSize:boundingRect options:options attributes:@{NSFontAttributeName:font} context:ctx];
    self.questionTextViewHeightConstraint.constant = CGRectGetHeight(textRect);
    
    boundingRect = CGSizeMake(CGRectGetWidth(self.answerTextView.frame), MAXFLOAT);
    textRect = [self.answerTextView.text boundingRectWithSize:boundingRect options:options attributes:@{NSFontAttributeName:font} context:ctx];
    self.answerTextViewHeightConstraint.constant = CGRectGetHeight(textRect);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)answersLoaded:(NSNotification *)notification {
    [self.answersTableView reloadData];
}

- (void)getLatestAnswers {
    [self.answerDataSource reload];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.answerTextView.text = @"";
    self.answerTextView.backgroundColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)saveAnswer {
    
    if (self.answerTextView.text.length > 0) {
//        // updating the table immediately
//        NSArray *keys = [NSArray arrayWithObjects:@"text", @"user", @"date", nil];
//        NSArray *objects = [NSArray arrayWithObjects:self.answerTextView.text, [PFUser currentUser], [NSDate date], nil];
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
////        [[self answers] addObject:dictionary];
//        
//        NSMutableArray *insertIndexPaths = [NSMutableArray array];
//        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [insertIndexPaths addObject:newPath];
//        [self.answersTableView beginUpdates];
//        [self.answersTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [self.answersTableView endUpdates];
//        [self.answersTableView reloadData];
        
        // going for the parsing
        Answer *answer = [[Answer alloc] init];
        answer.date = [NSDate date];
        answer.text = self.answerTextView.text;
        answer.questionId = self.question.objectId;
        [answer saveAnswer];
        self.answerTextView.text = @"";
    }
    [self loadAnswers];
}

- (void)doneEditing {
    [self.answerTextView resignFirstResponder];
    [self saveAnswer];
}

- (void)cancelEditing {
    self.answerTextView.text = @"";
    [self.answerTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Load Parse data

- (void)loadAnswers {
    [self.answerDataSource reload];
}

- (NSArray *)answers {
    return self.answerDataSource.answers;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self answers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *answerIdentifier = @"answerCell";
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:answerIdentifier forIndexPath:indexPath];
 
    // Configure the cell...
    cell.answer = [self answers][indexPath.row];
    cell.path = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Answer *answer = [self answers][indexPath.row];
    NSMutableParagraphStyle *mutableParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrahStyle.headIndent = 20.0;
    mutableParagrahStyle.firstLineHeadIndent = 20.0;
    mutableParagrahStyle.tailIndent = -20.0;
    mutableParagrahStyle.paragraphSpacingBefore = 5;
    NSParagraphStyle *paragraphStyle = mutableParagrahStyle;
    
    NSDate *theDate = answer.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm a"];
    NSString *timeString = [formatter stringFromDate:theDate];
    
    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
    CGSize maxLabelSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 40, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    UIFont *font = [UIFont systemFontOfSize:17];
    NSString *userNameAndTime = [NSString stringWithFormat:@"%@ - %@", answer.userName, timeString];
    CGRect usernameBounds = [userNameAndTime boundingRectWithSize:maxLabelSize options:options attributes:@{NSFontAttributeName : font} context:ctx];
    
    CGFloat height = usernameBounds.size.height;
    
    CGSize maxTextSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 40, MAXFLOAT);
    font = [UIFont systemFontOfSize:16];
    CGRect textBounds = [answer.text boundingRectWithSize:maxTextSize options:options attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName: paragraphStyle} context:ctx];
    height += textBounds.size.height;
    return height + 60;
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

#pragma mark - AnswerTableViewCellDelegate

- (void)answerRefreshedFor:(AnswerTableViewCell *)cell {
    NSLog(@"received delegate for cell %@", cell.path);
    [self.answersTableView reloadRowsAtIndexPaths:@[cell.path] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)likeButtonPressedFor:(Answer *)answer {
    [answer liked];
}

@end
