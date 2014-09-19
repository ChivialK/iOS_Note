//
//  ViewController.m
//  Note
//
//  Created by RavenC on 2014/9/19.
//  Copyright (c) 2014年 ChivialK. All rights reserved.
//

#import "NoteListViewController.h"
#import "DetailNoteViewController.h"
#import "NoteData.h"

#import "CustomSegue.h"
#import "CustomUnwindSegue.h"

@interface NoteListViewController () {
    NoteData *_noteData;
    NSArray *_feedItems;
    NSInteger *rowcount;
}
@end
@implementation NoteListViewController
@synthesize Notes, addButton, listTableView, syncButton; //View


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Create property list
    [self createEditableCopyOfDatabaseIfNeeded];
    
    //Set this view controller object as the delegate and data source for the table view
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    //Register for application exiting information so we can save data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    //property list
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"NotesList" ofType:@"plist"];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.Notes = tmpArray;
    
    //Create array object and assign it to _feedItems variable
    _feedItems = [[NSArray alloc] init];
    //Create new NoteData object and assign it to _noteData variable
    _noteData = [[NoteData alloc] init];
    //Set this view controller object as the delegate for the NoteData object
    _noteData.delegate = self;
    //Call the download items method of the NoteData object
    [_noteData downloadItems];
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}


#pragma Downloaded items method
-(void)itemsDownloaded:(NSArray *)items
{
    //Get called when the items are finished downloading
    //Set the downloaded items to the array
    _feedItems = items;
    
    //Reload the table view
    [self.listTableView reloadData];
}


#pragma Segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // NSLog(@"Segue preparing");
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
        DetailNoteViewController *noteDetailViewController = segue.destinationViewController;
        noteDetailViewController.Notedict = [self.Notes objectAtIndex:indexPath.row];
        noteDetailViewController.noteArray = self.Notes;
    }
    else if ([segue.identifier isEqualToString:@"addNote"]) {
        DetailNoteViewController *noteDetailViewController = segue.destinationViewController;
        noteDetailViewController.noteArray = self.Notes;
    }
}

/**
 // This is the IBAction method referenced in the Storyboard Exit for the Unwind segue.
 - (IBAction)returnedFromSegue:(UIStoryboardSegue *)sender {
 NSLog(@"Returned from other view");
 }
 
 - (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
 fromViewController:(UIViewController *)fromViewController
 identifier:(NSString *)identifier {
 
 // Check the identifier and return the custom unwind segue if this is an
 // unwind we're interested in
 if ([identifier isEqualToString:@"UnwindFromSecondView"]) {
 CustomUnwindSegue *segue = [[CustomUnwindSegue alloc]
 initWithIdentifier:identifier
 source:fromViewController
 destination:toViewController];
 return segue;
 }
 
 // return the default unwind segue otherwise
 return [super segueForUnwindingToViewController:toViewController
 fromViewController:fromViewController
 identifier:identifier];
 }
 **/

-(IBAction) addButtonPressed: (id) sender {
    
    NSLog(@"Add button pressed!");
    [self performSegueWithIdentifier:@"addNote" sender:self];
}

-(IBAction) syncButtonPressed: (id) sender {
    
    NSLog(@"Sync button pressed!");
    self.navigationItem.prompt = @"Syncing with host";
    [self.view setNeedsDisplay];
    
    for (id thisNote in Notes) {
        NSString *nindex = [thisNote objectForKey:@"Index"];// this is the name for to find the correct record.
        NSString *ntext = [thisNote objectForKey:@"Text"];
        NSDate *ndate = [thisNote objectForKey:@"CDate"];
        
        
        NSString *url = [NSString stringWithFormat:@"http://192.168.0.125:51212/firstapp/update.php?nid=%@&ntext=%@&ndate=%@", nindex, ntext, ndate];
        
        NSLog(@"Sending %@&%@",nindex, ntext);
        
        // build the request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *body= [NSMutableData data];
        [request setHTTPBody:body];
        
        // getting answer from the server.
        // you can echo message from the server let's say :"Update finish" or something like that...
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"returned: %@", returnString);
    }
    
    self.navigationItem.prompt = nil;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // important to reload data when view is redrawn
    [self.listTableView reloadData];
}


#pragma table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//number of rows in the table view.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [self.Notes count];
    return _feedItems.count;
}


//Customize table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Get the notes to be shown
    NoteData *item = _feedItems[indexPath.row];
    
    //theme info
    //cell.contentView.clipsToBounds = YES;
    //	[cell.contentView setBackgroundColor:[UIColor darkGrayColor]];
    //	[self.tableView reloadData];
    // Configure the cell.
    //cell.textLabel.backgroundColor = [UIColor darkGrayColor];
    
    //cell.textLabel.text = [[self.Notes objectAtIndex:indexPath.row ]objectForKey:@"Text"];
    cell.textLabel.text = item.notetext;
    
    
    NSDate *dateTmp;
    //dateTmp = [[self.Notes objectAtIndex:indexPath.row ]objectForKey:@"CDate"];
    
    cell.detailTextLabel.text = item.notedate;
    
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    //cell.detailTextLabel.text = [dateFormat stringFromDate: dateTmp];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


//Row selection in the table view.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"Row selected!");
    // Navigation logic may go here -- for example, create and push another view controller.
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

//Slide to delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Slide to delete triggered");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        
        NSIndexPath *nid = indexPath;// this is the name for to find the correct record.
        
        NSString *url = [NSString stringWithFormat:@"http://192.168.0.125:51212/firstapp/delete.php?nid=%@", nid];
        
        // build the request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *body= [NSMutableData data];
        [request setHTTPBody:body];
        
        // getting answer from the server.
        // you can echo message from the server let's say :"Update finish" or something like that...
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"returned: %@", returnString);
        
        [self.Notes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"Data delete !!");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma property list copy
-(void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence - we don't want to wipe out a user's DB
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    if (!dbexits) {
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NotesList.plist"];
        
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


-(void) applicationWillTerminate: (NSNotification *)notification {
    
    NSLog(@"got app will terminate");
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    
    [self.Notes writeToFile:path atomically:YES];
}

@end
