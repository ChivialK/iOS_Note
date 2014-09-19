//
//  DetailNoteViewController.h
//  Note
//
//  Created by RavenC on 2014/8/29.
//  Copyright (c) 2014年 ChivialK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DetailNoteViewController : UIViewController <UIAlertViewDelegate,UITextViewDelegate,UIActionSheetDelegate> {
    
    BOOL keyboardVisible;
    BOOL didEdit;
    
}

@property (strong, nonatomic) NSMutableArray* noteArray;
@property (strong, nonatomic) NSDictionary *Notedict;

@property (strong, nonatomic) IBOutlet UITextView *NoteText;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *save;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancel;



-(void)keyboardDidShow:(NSNotification *)notif;
-(void)keyboardDidHide:(NSNotification *)notif;
-(void)textViewDidChange:(UITextView *)NoteText;
-(void)savePlist;

- (IBAction) save: (id) sender;
- (IBAction) cancel: (id) sender;

@end
