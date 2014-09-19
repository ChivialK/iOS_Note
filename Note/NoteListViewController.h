//
//  ViewController.h
//  Note
//
//  Created by RavenC on 2014/9/19.
//  Copyright (c) 2014年 ChivialK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* Notes;
}

@property (strong, nonatomic) IBOutlet UIView *noteView;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *syncButton;

@property (retain, nonatomic) NSMutableArray* Notes;


- (IBAction) addButtonPressed:(id)sender;
- (IBAction) syncButtonPressed:(id)sender;
//- (IBAction) returnedFromSegue:(id)sender;

- (NSString *) applicationDocumentsDirectory;
- (void) createEditableCopyOfDatabaseIfNeeded;
- (void) applicationWillTerminate: (NSNotification *)notification;


@end

