//
//  ObjcViewController.m
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 25/10/2024.
//

#import "ObjcViewController.h"
#import "ContactTableViewCell.h"

@interface ObjcViewController ()
@property (weak, nonatomic) IBOutlet iOSComboBox *contactsComboBox;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *filteredContacts;
@end

@implementation ObjcViewController

static NSString* ContactCellIdentifier = @"ContactCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Objc + StoryBoard";
    
    _contacts = [NSMutableArray arrayWithObjects:
                 @"Oliver Smith",
                 @"Olivia Jones",
                 @"George Williams",
                 @"Amelia Taylor",
                 @"Harry Brown",
                 @"Isla Wilson",
                 @"Noah Evans",
                 @"Ava Thomas",
                 @"Jack Roberts",
                 @"Mia Johnson", nil];
    
    _filteredContacts = [_contacts mutableCopy];
        
    _contactsComboBox.borderStyle = UITextBorderStyleRoundedRect;
    _contactsComboBox.layer.borderWidth = 1.0;
    _contactsComboBox.layer.borderColor = [UIColor grayColor].CGColor;
    _contactsComboBox.layer.cornerRadius = 8.0;
    
    [_contactsComboBox registerCellClass:[ContactTableViewCell class] forCellReuseIdentifier:ContactCellIdentifier];
    _contactsComboBox.comboBoxDataSource = self;
    _contactsComboBox.comboBoxDelegate = self;
    _contactsComboBox.delegate = self;
    
    [_contactsComboBox addTarget:self
                          action:@selector(comboBoxTextDidChange:)
                forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)numberOfItemsIn:(iOSComboBox *)comboBox {
    return _filteredContacts.count;
}

- (CGFloat)comboBox:(iOSComboBox *)comboBox heightForRowAt:(NSInteger)index {
    return ContactTableViewCell.cellHeight;
}

- (id)comboBox:(iOSComboBox *)comboBox objectValueForItemAt:(NSInteger)index {
    return [_filteredContacts objectAtIndex:index];
}

- (UITableViewCell *)comboBox:(iOSComboBox *)comboBox cellProvider:(UITableViewCellProvider *)cellProvider forRowAt:(NSInteger)index {
    ContactTableViewCell* cell = (ContactTableViewCell*)[cellProvider dequeCellAtRow:index withIdentifier:ContactCellIdentifier];
    NSString *name = _filteredContacts[index];
    [cell configureWithContactName:name];
    return cell;
}

- (void)comboBox:(iOSComboBox *)comboBox commit:(UITableViewCellEditingStyle)editingStyle forRowAt:(NSInteger)index {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *name = [_filteredContacts objectAtIndex:index];
        [_filteredContacts removeObject:name];
        [_contacts removeObject:name];
    }
}

- (void)comboBox:(iOSComboBox *)comboBox didSelectRowAt:(NSInteger)index {
    [self includeNamesWithSubstring:comboBox.text ?: @""];
    _descriptionLabel.text = [NSString stringWithFormat:@"Selected: %@", comboBox.text];
}

-(void)comboBoxTextDidChange:(iOSComboBox*)comboBox{
    [self includeNamesWithSubstring:comboBox.text ?: @""];
    [_contactsComboBox reloadData];
}

- (void)includeNamesWithSubstring:(NSString *)substring {
    _filteredContacts = [_contacts mutableCopy];
    if (substring.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", substring];
        [_filteredContacts filterUsingPredicate:predicate];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
