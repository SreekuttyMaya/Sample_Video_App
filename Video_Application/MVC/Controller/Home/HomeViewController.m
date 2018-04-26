//
//  HomeViewController.m
//  Video_Application
//
//  Created by Sreekutty on 26/04/18.
//  Copyright © 2018 abc. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import <UIView+WebCache.h>
#import <AVKit/AVKit.h>

@interface HomeViewController ()
{
    
    __weak IBOutlet UICollectionView *collectionView_images;
    __weak IBOutlet UIView *view_video;
    __weak IBOutlet UIScrollView *scrollView;
    
    NSMutableArray *array_images;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //load image to load in carousel
    array_images = [NSMutableArray new];
    for (int i = 0; i < 7; i++) {
        [array_images addObject:[NSString stringWithFormat:@"https://picsum.photos/%d/%d",(i+1)*100,(i+2)*100]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self playVideoSetUp];
    
}

-(void)playVideoSetUp {
    
    NSString *urlString=[NSString stringWithFormat:@"%@",@"http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8"];
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:urlString]];
    AVPlayerItem *avPlayerItem = [[AVPlayerItem alloc]initWithAsset:asset];
    AVPlayer *songPlayer = [AVPlayer playerWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer: songPlayer];
    avPlayerLayer.frame = view_video.layer.bounds;
    songPlayer.muted = YES;
    [view_video.layer addSublayer:avPlayerLayer];
    dispatch_async(dispatch_get_main_queue(), ^{
        [songPlayer play];
    });
}

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
