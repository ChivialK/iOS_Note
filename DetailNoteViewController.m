//
//  DetailNoteViewController.m
//  Note
//
//  Created by RavenC on 2014/8/29.
//  Copyright (c) 2014年 ChivialK. All rights reserved.
//

#import "DetailNoteViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NoteListViewController.h"

@interface DetailNoteViewController ()

@end

@implementation DetailNoteViewController
@synthesize toolBar, save, cancel;
@synthesize NoteText, noteArray, Notedict;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    NoteText.delegate = self;
    didEdit = NO;
    keyboardVisible = NO;
    //NoteDetail.contentSize = self.view.frame.size;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.Notedict != nil) {
        NoteText.text = [Notedict objectForKey:@"Text"];
        
    } else {
        NoteText.text = @"";
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    //NSLog (@"Unregsitering for keyboard events");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //if we edited lets save the note in case we're exiting for a text or incoming call
    if (didEdit) {
        [self savePlist];
        
    }
}

#pragma mark Segue
- (IBAction)returnToFirst:(id)sender {
    [self performSegueWithIdentifier:@"goBack" sender:self];
}

#pragma mark - Keyboard
-(void) keyboardDidShow: (NSNotification *)notif {
    if (keyboardVisible) {
        NSLog(@"Keyboard is already visible. Ignoring notofication.");
        return;
    }
/**
    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    //resize the scroll view
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= (keyboardSize.height);
    viewFrame.size.height -= [toolBar frame].size.height;
    //NoteDetail.frame = viewFrame;
**/
    
    //change the button to a done instead of save
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
    
/**
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardSize.height;
    NoteDetail.frame = viewFrame;
**/
    
    if (!keyboardVisible) {
        NSLog(@"Keyboard is already hidden. Ignoring notification.");
        return;
    }
    
    keyboardVisible = NO;
}

#pragma mark - Button
- (IBAction) save: (id) sender {
    
    if(keyboardVisible){
        NSLog(@"Save pressed 1! Keyboard hide!");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
        [NoteText resignFirstResponder];
        keyboardVisible=NO;
        return;
    }
    
    NSLog(@"Save pressed 2. Data saved!");
        
    [self savePlist]; //propertylist
        
    //return to table view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) savePlist{
    
    // Create a new  dictionary for the new values
    NSMutableDictionary* newNote = [[NSMutableDictionary alloc] init];
    
    [newNote setValue:NoteText.text forKey:@"Text"];
    [newNote setObject:[NSDate date] forKey:@"CDate"];
    
    
    if(self.Notedict != nil){
        // We're working with an exisitng note, so let's remove
        // it from the array to get ready for a new one
        [noteArray removeObject:Notedict];
        self.Notedict = nil; //This will release our reference too
        
    }
    
    // Add it to the master  array and release our reference
    [noteArray addObject:newNote];
    
    //important, without this it double creates your saved note on exit due to saving on viewWillDissapear
    didEdit = NO;
    
    // Sort the array since we just aded a new drink
    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"CDate" ascending:NO selector:@selector(compare:)];
    [noteArray sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
    
}

- (IBAction) cancel: (id) sender {
    
    NSLog(@"Cancel pressed!");
    // handle popup warning of unsaved changes
    
    if(!didEdit) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        // open a alert with an OK and cancel button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsaved Changes!" message:@"Close without saving?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0) {
        NSLog(@"cancel");
        
    } else {
        NSLog(@"ok");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)textViewDidChange:(UITextView *)NoteText{
    
    //text field has started edit session show warning on cancel without save
    didEdit = YES;
    //NSLog(@"didEdit=YES");
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
    //	NSLog(@"viewDidUnload");
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
