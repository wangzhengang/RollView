//
//  ViewController.m
//  RollViewDemo
//
//  Created by 王振钢 on 2019/6/27.
//  Copyright © 2019 王振钢. All rights reserved.
//

#import "ViewController.h"
#import "RollView.h"

@interface ViewController ()<RollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    NSString *text = @"我在滚动【1】我在滚动【2】我在滚动【3】我在滚动【4】";
    CGRect frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, 30);
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 100, 30)];
    [lab setAttributedText:att];
    [lab sizeToFit];
    RollView *textView1 = [[RollView alloc] initWithFrame:frame delegate:self duration:5.f direction:RollDirectionLeft custom:lab];
    [textView1 setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:textView1];
    [textView1 start];
    
    
    
    frame = CGRectMake(20, 150, self.view.bounds.size.width - 40, 30);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 200, 30)];
    [btn setTitle:@"图文滚动" forState:UIControlStateNormal];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [btn setImage:image forState:UIControlStateNormal];
    RollView *textView2 = [[RollView alloc] initWithFrame:frame delegate:self duration:5.f direction:RollDirectionRight custom:btn];
    [textView2 setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:textView2];
    [textView2 start];
    
    
    
    text = @"我在滚动【1】我在滚动【2】我在滚动【3】我在滚动【4】";
    frame = CGRectMake(20, 200, 100, 100);
    NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [lab2 setAttributedText:att2];
    lab2.numberOfLines = 0;
    RollView *textView3 = [[RollView alloc] initWithFrame:frame delegate:self duration:2 direction:RollDirectionUp custom:lab2];
    [textView3 setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:textView3];
    [textView3 start];
    [textView3 start];

    
    frame = CGRectMake(150, 200, 100, 100);
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 100, 100)];
    [btn setTitle:@"图文滚动" forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(30, 0, 0, -30)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(-10, -10, 10, 0)];
    RollView *textView4 = [[RollView alloc] initWithFrame:frame delegate:self duration:2 direction:RollDirectionDown custom:btn];
    [textView4 setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:textView4];
    [textView4 start];
    [textView4 start];
    [textView4 start];

    
}

- (void)rollViewSate:(RollViewState)state customView:(nonnull UIView *)view {
//    NSLog(@"view: %@, state: %@", view, @(state));
    NSLog(@"state: %@", @(state));
}



@end
