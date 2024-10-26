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
@end

@implementation ObjcViewController

static NSString* ContactCellIdentifier = @"ContactCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
    _contactsComboBox.borderStyle = UITextBorderStyleRoundedRect;
    [_contactsComboBox registerCellClass:[ContactTableViewCell class] forCellReuseIdentifier:ContactCellIdentifier];
    _contactsComboBox.comboBoxDataSource = self;
    _contactsComboBox.comboBoxDelegate = self;
    
    UITableView *tableView;
    [tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:@"ContactCell"];
}

- (NSInteger)numberOfItemsIn:(iOSComboBox *)comboBox {
    return _contacts.count;
}

- (CGFloat)comboBox:(iOSComboBox *)comboBox heightForRowAt:(NSInteger)index {
    return ContactTableViewCell.cellHeight;
}

- (id)comboBox:(iOSComboBox *)comboBox objectValueForItemAt:(NSInteger)index {
    return [_contacts objectAtIndex:index];
}

- (UITableViewCell *)comboBox:(iOSComboBox *)comboBox cellProvider:(UITableViewCellProvider *)cellProvider forRowAt:(NSInteger)index {
    ContactTableViewCell* cell = (ContactTableViewCell*)[cellProvider dequeCellAtRow:index withIdentifier:ContactCellIdentifier];
    NSString *name = _contacts[index];
    [cell configureWithContactName:name];
    return cell;
}

- (void)comboBox:(iOSComboBox *)comboBox commit:(UITableViewCellEditingStyle)editingStyle forRowAt:(NSInteger)index {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_contacts removeObjectAtIndex:index];
    }
}

- (void)comboBox:(iOSComboBox *)comboBox didSelectRowAt:(NSInteger)index {
    _descriptionLabel.text = [NSString stringWithFormat:@"Selected: %@", comboBox.text];
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
