//
//  ViewController.m
//  mapView4
//
//  Created by Summer on 17/4/11.
//  Copyright © 2017年 omychic. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "YFannovation.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCon;
@property(nonatomic, strong) CLLocationManager *mgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mgr = [CLLocationManager new];
    [self.mgr requestWhenInUseAuthorization];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    self.mapView.delegate = self;
    
    self.mapView.showsScale = YES;
    self.mapView.showsCompass = YES;
    self.mapView.showsTraffic = YES;
    
    self.mapView.showsPointsOfInterest = YES;
    //    self.mapView.showsBuildings = YES;
    //    self.mapView.camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(39.9, 116.4) fromDistance:50 pitch:75 heading:0];
}


//返回原来的展示区域
- (IBAction)backClick:(UIButton *)sender {
    
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, self.mapView.region.span)];
    
}

//放大地图
- (IBAction)ZoomInClick:(UIButton *)sender {
    
    //跨度变为原来的1/2
    MKCoordinateSpan span = MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta *0.5, self.mapView.region.span.longitudeDelta *0.5);
    
    MKCoordinateRegion regin = MKCoordinateRegionMake(self.mapView.region.center, span);
    
    [self.mapView setRegion:regin animated:YES];
    
}

////缩小地图
- (IBAction)ZoomOutClick:(UIButton *)sender {
    
    
     //跨度变为原来的2倍
    MKCoordinateSpan span = MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta *2, self.mapView.region.span.longitudeDelta*2);
    
    MKCoordinateRegion regin = MKCoordinateRegionMake(self.mapView.region.center, span);
    
    [self.mapView setRegion:regin animated:YES];
    
}

//根据不同的segment选择不同的地图展示方式
- (IBAction)secClick:(UISegmentedControl *)sender {
    
    long index = sender.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 3:
            self.mapView.mapType = MKMapTypeSatelliteFlyover;
            break;
        case 4:
            self.mapView.mapType = MKMapTypeHybridFlyover;
            break;

        default:
            break;
    }
    
    
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  
    CLGeocoder *coder = [CLGeocoder new];
    
    [coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        self.mapView.userLocation.title = placemarks.lastObject.locality;
        self.mapView.userLocation.subtitle = placemarks.lastObject.name;
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    YFannovation *anno = [YFannovation new];
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.mapView];
    anno.coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    [self.mapView addAnnotation:anno];
    
    
}

//自定义AnnoView
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"aa"];
    
    if (annoView == nil) {
        
        annoView = [MKAnnotationView new];
        annoView.image = [UIImage imageNamed:@"piggy"];
        annoView.canShowCallout = YES;
        
    }
    
    return annoView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
