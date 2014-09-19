//
//  NoteData.h
//  FirstApp
//
//  Created by RavenC on 2014/9/2.
//  Copyright (c) 2014年 ChivialK. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NoteDataProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface NoteData : NSObject <NSURLConnectionDataDelegate> {
    
}

@property (nonatomic, weak) id<NoteDataProtocol> delegate;

- (void)downloadItems;


@property (nonatomic, strong) NSString *noteid;
@property (nonatomic, strong) NSString *notetext;
@property (nonatomic, strong) NSDate *notedate;

@end
