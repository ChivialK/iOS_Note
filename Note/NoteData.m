//
//  NoteData.m
//  FirstApp
//
//  Created by RavenC on 2014/9/2.
//  Copyright (c) 2014年 ChivialK. All rights reserved.
//

#import "NoteData.h"

@interface NoteData()
{
    NSMutableData *_downloadedData;
}
@end

@implementation NoteData
@synthesize noteid,notetext,notedate;

- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://192.168.0.125:51212/firstapp/service.php"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    NSMutableArray *_notes = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        NoteData *newNotes = [[NoteData alloc] init];
        newNotes.noteid = jsonElement[@"noteid"];
        newNotes.notetext = jsonElement[@"notetext"];
        newNotes.notedate = jsonElement[@"notedate"];
        
        // Add this question to the locations array
        [_notes addObject:newNotes];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_notes];
    }
}


@end
