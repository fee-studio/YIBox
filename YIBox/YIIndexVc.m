//
//  YIIndexVc.m
//  YIBox
//
//  Created by efeng on 16/1/31.
//  Copyright © 2016年 buerguo. All rights reserved.
//

#import "YIIndexVc.h"
#import "YIBlurVc.h"
#import "YINineGridVc.h"
#import "YIFlashlightVc.h"


@interface YIIndexVc ()

@property (nonatomic, strong) NSArray *tools;

@end

@implementation YIIndexVc

- (void)viewDidLoad {
    [super viewDidLoad];	
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:NSStringFromClass(self.class)];
	
	[self loadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)loadData {
	NSString *flashlightDetail = @"";
	if (mGlobalData.flashlight.type == FlashlightTypeScreen) {
		flashlightDetail =@"屏幕光";
	} else if (mGlobalData.flashlight.type == FlashlightTypeFlash) {
		flashlightDetail =@"闪光灯";
	}
	self.tools = @[
				   @{
					   @"image" : @"gaosimohu",
					   @"name" : @"图片-高斯模糊效果",
					   @"detail" : @"",
					   @"target" : NSStringFromClass(YIBlurVc.class)
					 },
				   @{
					   @"image" : @"ninegrid",
					   @"name" : @"朋友圈-九宫分图",
					   @"detail" : @"",
					   @"target" : NSStringFromClass(YINineGridVc.class)
					   },
				   @{
					   @"image" : @"flashlight_icon",
					   @"name" : @"手电筒",
					   @"detail" : flashlightDetail,
					   @"target" : NSStringFromClass(YIFlashlightVc.class)
					   },
				   ];
	[self.baseTableView reloadData];
}

#pragma mark - table view delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _tools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"IndexCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.imageView.image = [UIImage imageNamed:_tools[indexPath.row][@"image"]];
	cell.textLabel.text = _tools[indexPath.row][@"name"];
	cell.textLabel.textColor = kAppTextDeepColor;
	cell.detailTextLabel.text = _tools[indexPath.row][@"detail"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	id className = _tools[indexPath.row][@"target"];
	if (className == nil || [className isKindOfClass:[NSNull class]] ) {
		
	} else {
		Class target = NSClassFromString(_tools[indexPath.row][@"target"]);
		YIBaseViewController *vc = [[target alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
//	return 20.f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
//	return 0.01f;
//}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
