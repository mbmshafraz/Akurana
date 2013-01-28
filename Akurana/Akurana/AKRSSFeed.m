//
//  AKRSSFeed.m
//  Akurana
//

/*
 
 Copyright (c) 2012, Shafraz Buhary
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the Copyright holder  nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "AKRSSFeed.h"
#import <UIKit/UIKit.h>

@interface AKRSSFeed()

@property (nonatomic, weak) id<AKRSSFeedDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *item;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSMutableString *currentTitle;
@property (nonatomic, copy) NSMutableString *currentDate;
@property (nonatomic, copy) NSMutableString *currentDescription;
@property (nonatomic, copy) NSMutableString *currentLink;

@end


@implementation AKRSSFeed


#pragma mark Private

- (void)parseRSSFeedData:(NSData *)data withDelegate:(id<AKRSSFeedDelegate>)delegate
{	
	self.delegate  = delegate;
    self.stories   = [NSMutableArray new];
    self.rssParser = [[NSXMLParser alloc] initWithData:data];
    [self.rssParser setDelegate:self];
    [self.rssParser setShouldProcessNamespaces:NO];
    [self.rssParser setShouldReportNamespacePrefixes:NO];
    [self.rssParser setShouldResolveExternalEntities:NO];
	
    [self.rssParser parse];
}

#pragma mark NSXMLParser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSString * errorString = [NSString 
	  stringWithFormat:@"Unable to get feed (Error code %i )",
	  [parseError code]];
	NSLog(@"Error parsing XML: %@", errorString);
	
#ifdef DEBUG
	UIAlertView * errorAlert = [[UIAlertView alloc]
	  initWithTitle:@"Error loading content" message:errorString delegate:self
	  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
#endif
    
    [self.delegate didFailParseFeed:self withError:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
  attributes:(NSDictionary *)attributeDict
{			
	_currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"]) {
		self.item         = [NSMutableDictionary new];
		self.currentTitle = [NSMutableString new];
		self.currentDate  = [NSMutableString new];
		self.currentDescription = [NSMutableString new];
		self.currentLink  = [NSMutableString new];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	
	if ([elementName isEqualToString:@"item"]) {
		
		self.item[@"title"]       = self.currentTitle;
		self.item[@"description"] = self.currentDescription;
		self.item[@"pubDate"]     = self.currentDate;
		
        NSString *storyLink = _currentLink;
        storyLink = [storyLink stringByReplacingOccurrencesOfString:@" "
		  withString:@""];
        storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n"
		  withString:@""];
        storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	"
		  withString:@""];
        self.item[@"link"] = storyLink;

		[self.stories addObject:self.item];
		
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//HHLOG(@"found characters: %@", string);
	// Save the characters for the current item...
	if ([_currentElement isEqualToString:@"title"]) {
		[_currentTitle appendString:string];
	} else if ([_currentElement isEqualToString:@"link"]) {
		[_currentLink appendString:string];
	} else if ([_currentElement isEqualToString:@"description"]) {
		[_currentDescription appendString:string];
	} else if ([_currentElement isEqualToString:@"pubDate"]) {
		[_currentDate appendString:string];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	SEL callback = @selector(didParseFeed:toStories:);
	if ([_delegate respondsToSelector:callback])
		[_delegate didParseFeed:self toStories:_stories];
    //NSLog(@"Stories%@",_stories);
}

#pragma mark TTURLRequestDelegate

//- (void)requestDidFinishLoad:(TTURLRequest*)request
//{
//    TTURLDataResponse* response = [request response];
//    [self parseXMLData:[response data]];
//}
//
//- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
//{}


- (void)didParseFeed:(AKRSSFeed *)feed toStories:(NSArray *)stories
{
}

- (void)didFailParseFeed:(AKRSSFeed *)feed withError:(NSError *)error
{
}

@end
