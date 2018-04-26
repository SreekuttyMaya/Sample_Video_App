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
    
    NSMutableArray *array_images;
    AVPlayer *songPlayer;
    
    BOOL isScroll;
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
    //setup player
    [self playVideoSetUp];
}

#pragma mark - Custom Methods

-(void)playVideoSetUp {
    
    NSString *urlString=[NSString stringWithFormat:@"%@",@"http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8"];
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:urlString]];
    AVPlayerItem *avPlayerItem = [[AVPlayerItem alloc]initWithAsset:asset];
    songPlayer = [AVPlayer playerWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer: songPlayer];
    avPlayerLayer.frame = view_video.layer.bounds;
    songPlayer.muted = YES;
    [view_video.layer addSublayer:avPlayerLayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:[songPlayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:[songPlayer currentItem]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [songPlayer play];
    });
}


- (void)videoDidFinish:(id)videoNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [songPlayer play];
    });
}

#pragma mark - Collection View Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return array_images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell_images";
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imagView = (UIImageView *)[cell viewWithTag:101];
    [imagView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imagView sd_setShowActivityIndicatorView:YES];
    [imagView sd_setImageWithURL:[NSURL URLWithString:array_images[indexPath.row]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
        }
    }];
    cell.tag =indexPath.row;
    return cell;
}

#pragma mark - Collection View Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ///to display three cells
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    float cellWidth = screenWidth / 3.0;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

#pragma mark - IBActions

- (IBAction)btnAction_previous:(id)sender {
    isScroll = NO;
    if(collectionView_images.contentOffset.x <= 0){//reached first

        NSString *string = array_images.lastObject;
        [array_images
         removeObjectAtIndex:array_images.count-1];
        [array_images insertObject:string atIndex:0];
        [collectionView_images reloadData];
    } else {
        CGFloat contentOffset =floor(collectionView_images.contentOffset.x + (collectionView_images.bounds.size.width/3));
        
        CGRect frame = CGRectMake(contentOffset, collectionView_images.contentOffset.y, collectionView_images.frame.size.width, collectionView_images.frame.size.height);
        [collectionView_images scrollRectToVisible:frame animated:YES];
    }
}


- (IBAction)btnAction_next:(id)sender {
    isScroll = NO;
    
    if(collectionView_images.contentSize.width >= (array_images.count * (collectionView_images.bounds.size.width/3))){//reached end
        NSString *string = [array_images
                            objectAtIndex:0];
        [array_images insertObject:string atIndex:array_images.count];
        [array_images
         removeObjectAtIndex:0];
        [collectionView_images reloadData];
    } else {
        CGFloat contentOffset =floor(collectionView_images.contentOffset.x + (collectionView_images.bounds.size.width/3));
        
        CGRect frame = CGRectMake(contentOffset, collectionView_images.contentOffset.y, collectionView_images.frame.size.width, collectionView_images.frame.size.height);
        [collectionView_images scrollRectToVisible:frame animated:YES];
    }
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
