//
//  LKDBViewController.m
//  DemoSYCacheManager
//
//  Created by zhangshaoyu on 2017/7/22.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "LKDBViewController.h"
#import "LKDBModel.h"
#import "SYCacheManager.h"

@interface LKDBViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) SYCacheManager *cacheManager;
@property (nonatomic, strong) LKDBModel *model;

@property (nonatomic, strong) NSArray *array;

@end

@implementation LKDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"LKDB缓存管理";
    
    self.array = @[@"存数据", @"取数据", @"删除数据", @"修改数据", @"创建表", @"删除表"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = self.editView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    if (0 == indexPath.row)
    {
        // 存数据
        if (self.model)
        {
            LKDBModel *model = [LKDBModel new];
            model.name = ((UITextField *)[self.editView viewWithTag:1000]).text;
            model.age = ((UITextField *)[self.editView viewWithTag:1001]).text;
            model.company = ((UITextField *)[self.editView viewWithTag:1002]).text;
            
            [self.cacheManager saveModel:model];
        }
        else
        {
            self.model = [LKDBModel new];
            self.model.name = @"devZhang";
            self.model.age = @"30";
            self.model.company = @"VSTECS";
            
            [self.cacheManager saveModel:self.model];
        }
    }
    else if (1 == indexPath.row)
    {
        // 取数据
        NSString *company = ((UITextField *)[self.editView viewWithTag:1002]).text;
        NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
        where = ((company && 0 < company.length) ? where : nil);
        NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
        for (LKDBModel *model in array)
        {
            NSString *value = [NSString stringWithFormat:@"name = %@, age = %@, company = %@", model.name, model.age, model.company];
            NSLog(@"model = %@", value);
        }
    }
    else if (2 == indexPath.row)
    {
        // 删除数据
        //
//        [self.cacheManager deleteModel:self.model];
        //
        NSString *company = ((UITextField *)[self.editView viewWithTag:1002]).text;
        NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
        [self.cacheManager deleteModel:[LKDBModel class] where:where];
    }
    else if (3 == indexPath.row)
    {
        // 修改数据
        
        if (self.model)
        {
            self.model.age = @"30+1";
        }
        
        [self.cacheManager updateModel:self.model];
    }
    else if (4 == indexPath.row)
    {
        // 创建表
        [self.cacheManager newTableWithModel:[LKDBModel class]];
    }
    else if (5 == indexPath.row)
    {
        // 删除表
        [self.cacheManager deleteTableWithModel:[LKDBModel class]];
    }
}

#pragma mark - 编译视图

- (UIView *)editView
{
    if (_editView == nil)
    {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 60.0)];
        _editView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        
        CGFloat width = (_editView.frame.size.width - 10.0 * 4) / 3;
        UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, width, (_editView.frame.size.height - 10.0 * 2))];
        [_editView addSubview:nameTextField];
        nameTextField.tag = 1000;
        nameTextField.placeholder = @"姓名";
        nameTextField.textColor = [UIColor blackColor];
        nameTextField.layer.cornerRadius = 3.0;
        nameTextField.layer.borderColor = [UIColor orangeColor].CGColor;
        nameTextField.layer.borderWidth = 1.0;
        
        UIView *currentView = nameTextField;
        
        UITextField *ageTextField = [[UITextField alloc] initWithFrame:CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + 10.0), 10.0, width, (_editView.frame.size.height - 10.0 * 2))];
        [_editView addSubview:ageTextField];
        ageTextField.tag = 1001;
        ageTextField.placeholder = @"年龄";
        ageTextField.textColor = [UIColor greenColor];
        ageTextField.layer.cornerRadius = 3.0;
        ageTextField.layer.borderColor = [UIColor brownColor].CGColor;
        ageTextField.layer.borderWidth = 1.0;
        
        currentView = ageTextField;
        
        UITextField *companyTextField = [[UITextField alloc] initWithFrame:CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + 10.0), 10.0, width, (_editView.frame.size.height - 10.0 * 2))];
        [_editView addSubview:companyTextField];
        companyTextField.tag = 1002;
        companyTextField.placeholder = @"公司";
        companyTextField.textColor = [UIColor blueColor];
        companyTextField.layer.cornerRadius = 3.0;
        companyTextField.layer.borderColor = [UIColor purpleColor].CGColor;
        companyTextField.layer.borderWidth = 1.0;
    }
    return _editView;
}

- (SYCacheManager *)cacheManager
{
    if (_cacheManager == nil)
    {
        _cacheManager = [[SYCacheManager alloc] init];
    }
    return _cacheManager;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end