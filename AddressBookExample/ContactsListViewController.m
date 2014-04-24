//
//  MasterViewController.m
//  AddressBookExample
//
//  Created by alexander on 4/24/14.
//  Copyright (c) 2014 Uriphium. All rights reserved.
//

#import "ContactsListViewController.h"
#import "ContactTableViewCell.h"

#import "AddressBook.h"

@interface ContactsListViewController () {
    RHAddressBook *_addressBook;
    __weak IBOutlet UISearchBar *searchbar;
    
    NSMutableArray *_addedPerson;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) NSMutableArray *sections;

@end

@implementation ContactsListViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}
- (IBAction)done:(id)sender {
    
    if (_addPersonBlock!=nil) {
        _addPersonBlock([_addressBook copy]);
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _addedPerson = [NSMutableArray array];
    
    _addressBook = [[RHAddressBook alloc] init];
    
    NSArray *allPeople = [_addressBook people];
    
    [self setObjects:allPeople];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    RHPerson *person =  _sections[indexPath.section][indexPath.row];
    
    cell.added = [_addedPerson containsObject:person];
    
    cell.nameLabel.text = [person name];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = (ContactTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    RHPerson *person =  _sections[indexPath.section][indexPath.row];
    
    BOOL added = [_addedPerson containsObject:person];
    
    if (added) {
        
        [_addedPerson removeObject:person];
        
    }else{
        
        [_addedPerson addObject:person];
    }
    
    cell.added = !added;
    
    
    if (_addedPerson.count>0&&self.navigationItem.rightBarButtonItem==nil) {
        
        [self.navigationItem setRightBarButtonItem:self.doneButton];
        
    }else if (_addedPerson.count==0&&self.navigationItem.rightBarButtonItem!=nil){
        
        [self.navigationItem setRightBarButtonItem:nil];
    }
}



- (void)setObjects:(NSArray *)objects {

    NSInteger  sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects) {
        
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:@selector(lastName)];
        
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:@selector(lastName)]];
    }
    
    self.sections = mutableSections;
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}
@end
