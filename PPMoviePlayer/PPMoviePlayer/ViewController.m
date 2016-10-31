//
//  ViewController.m
//  PPMoviePlayer
//
//  Created by cdmac on 16/10/26.
//  Copyright © 2016年 chinadailyhk. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerVC1.h"
#import "AVPlayerVC2.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"AVKit Demo";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMovie:(id)sender {
    AVPlayerVC1 *pushVC = [[AVPlayerVC1 alloc] init];
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (IBAction)playCustom:(id)sender {
    AVPlayerVC2 *pushVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Player2"];

    [self.navigationController pushViewController:pushVC animated:YES];
}

@end
