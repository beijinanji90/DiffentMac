//
//  ViewController.m
//
//
//  Created by chenfenglong on 16/8/5.
//  Copyright © 2016年 chenfenglong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSButton *fileABtn;
@property (weak) IBOutlet NSButton *fileBBtn;
@property (weak) IBOutlet NSButton *compareBtn;
@property (weak) IBOutlet NSButton *restateBtn;

@property (weak) IBOutlet NSTableView *fileTableA;
@property (weak) IBOutlet NSTableView *fileTableB;
@property (weak) IBOutlet NSTableView *fileTableC;

@property (nonatomic,strong) NSMutableArray *arrayA;

@property (nonatomic,strong) NSMutableArray *arrayB;

@property (nonatomic,strong) NSMutableArray *result;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayA = [NSMutableArray array];
    self.arrayB = [NSMutableArray array];
    self.result = [NSMutableArray array];
}

- (IBAction)fileAClick:(NSButton *)sender
{
    NSOpenPanel *panel;
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"txt", nil];
    panel = [NSOpenPanel openPanel];
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:fileTypes];
    NSInteger i = [panel runModal];
    if(i == NSModalResponseOK)
    {
        NSString *filePath = [[[panel URLs] lastObject] path];;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            NSArray *arrayString = [fileString componentsSeparatedByString:@"\n"];
            [arrayString enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *newString = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (newString.length != 0 && [newString longLongValue] != 0) {
                    NSLog(@"a -- %@",newString);
                    [self.arrayA addObject:newString];
                }
            }];
        }
        sender.enabled = NO;
        [self.fileTableA reloadData];
    }
}

- (IBAction)fileBClick:(id)sender
{
    NSOpenPanel *panel;
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"txt", nil];
    panel = [NSOpenPanel openPanel];
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:fileTypes];
    NSInteger i = [panel runModal];
    if(i == NSModalResponseOK)
    {
        NSString *filePath = [[[panel URLs] lastObject] path];;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            NSArray *arrayString = [fileString componentsSeparatedByString:@"\n"];
            self.arrayB = [NSMutableArray array];
            [arrayString enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *newString = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (newString.length != 0 && [newString longLongValue] != 0) {
                    [self.arrayB addObject:newString];
                }
            }];
        }
        ((NSButton *)sender).enabled = NO;
        [self.fileTableB reloadData];
    }
}

- (IBAction)compareClick:(id)sender
{
    NSLog(@"arrayA -- %@",self.arrayA);
    NSLog(@"arrayB -- %@",self.arrayB);
    [self.result removeAllObjects];
    [self.arrayA enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.arrayB containsObject:obj] == NO) {
            [self.result addObject:obj];
        }
    }];
    ((NSButton *)sender).enabled = NO;
    [self.fileTableC reloadData];
}

- (IBAction)restateClick:(id)sender {
    [self.arrayA removeAllObjects];
    [self.arrayB removeAllObjects];
    [self.result removeAllObjects];
    [self.fileTableA reloadData];
    [self.fileTableB reloadData];
    [self.fileTableC reloadData];
    self.fileABtn.enabled = YES;
    self.fileBBtn.enabled = YES;
    self.restateBtn.enabled = YES;
    self.compareBtn.enabled = YES;
}


#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == (NSTableView *)self.fileTableA) {
        return self.arrayA.count;
    }
    else if(tableView == (NSTableView *)self.fileTableB)
    {
        return self.arrayB.count;
    }
    else if(tableView == (NSTableView *)self.fileTableC)
    {
        return self.result.count;
    }
    return 0;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *cellValue = nil;
    if (tableView == self.fileTableA)
    {
        cellValue = [self.arrayA objectAtIndex:row];
    }
    else if(tableView == self.fileTableB)
    {
        cellValue = [self.arrayB objectAtIndex:row];
    }
    else if(tableView == self.fileTableC)
    {
        cellValue = [self.result objectAtIndex:row];
    }
    return cellValue;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 22;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}


@end
