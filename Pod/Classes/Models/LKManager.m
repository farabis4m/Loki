//
//  LKManager.m
//
//  Created by Vlad Gorbenko on 4/21/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "LKManager.h"

#import "NSBundle+Language.h"

NSString *const LKLanguageDidChangeNotification = @"LKLanguageDidChangeNotification";
NSString *const LKLanguageKey = @"LKLanguage";

NSString *LKLocalizationFilename = @"Localization";

NSString *LKLocalizedString(NSString *key, NSString *comment) {
    return [[LKManager sharedInstance] titleForKeyPathIdentifier:key];
}

@implementation LKManager

@synthesize currentLanguage = _currentLanguage;

#pragma - Singleton

+ (LKManager*)sharedInstance{
    static LKManager *localizationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizationManager = [[self alloc] init];
    });
    return localizationManager;
}

+ (void)nextLanguage {
    LKManager *manager = [LKManager sharedInstance];
    NSUInteger currentLanguageIndex = [manager.languages indexOfObject:manager.currentLanguage];
    currentLanguageIndex = currentLanguageIndex + 1 < manager.languages.count ? currentLanguageIndex + 1 : 0;
    manager.currentLanguage = manager.languages[currentLanguageIndex];
    
    NSLog(@"%@", manager.currentLanguage.name);
}

+ (void)setLocalizationFilename:(NSString *)localizationFilename {
    LKLocalizationFilename = localizationFilename;
}

+ (void)addLanguage:(LKLanguage *)language {
    if(![[self languages] containsObject:language]) {
        [[self languages] addObject:language];
    }
}

+ (void)removeLanguage:(LKLanguage *)language {
    if([[self languages] containsObject:language]) {
        [[self languages] removeObject:language];
    }
}

#pragma - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _vocabluary = [self setupVocabluary];
    }
    return self;
}

- (NSDictionary*)setupVocabluary {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:LKLocalizationFilename ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

#pragma mark - Accessors

- (NSArray *)languages {
    return [[[self class] languages] copy];
}

- (LKLanguage *)currentLanguage{
    if (!_currentLanguage) {
        NSString *systemLanguageCode = [NSLocale preferredLanguages].firstObject;
        NSString *languageCode = [[NSUserDefaults standardUserDefaults] valueForKey:LKLanguageKey];
        _currentLanguage = [self languageByCode:languageCode ?: systemLanguageCode];
        NSAssert(_currentLanguage, @"Language doesn't exist");
    }
    return _currentLanguage;
}

#pragma mark - Modifiers

- (void)setCurrentLanguage:(LKLanguage *)currentLanguage{
    if (_currentLanguage != currentLanguage) {
        _currentLanguage = currentLanguage;
        
        [NSBundle setLanguage:currentLanguage.code];
        
        [[NSUserDefaults standardUserDefaults] setValue:_currentLanguage.code forKey:LKLanguageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:LKLanguageDidChangeNotification object:nil];
    }
}

#pragma mark - Utils

- (LKLanguage*)languageByCode:(NSString*)code{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", code];
    return [self.languages filteredArrayUsingPredicate:predicate].firstObject;
}

- (NSString *)titleForKeyPathIdentifier:(NSString *)keyPathIdentifier {
    return [self titleForKeyPathIdentifier:keyPathIdentifier preferredLanguage:self.currentLanguage.code];
}

- (NSString *)titleForKeyPathIdentifier:(NSString *)keyPathIdentifier preferredLanguage:(NSString *)languageCode{
    if([_vocabluary valueForKey:keyPathIdentifier]){
        return [[_vocabluary valueForKey:keyPathIdentifier] valueForKey:languageCode];
    }else{
        return [NSString stringWithFormat:@"%@", keyPathIdentifier];
    }
}

+ (NSMutableArray *)simpleViews {
    static dispatch_once_t onceToken;
    static NSMutableArray *items = nil;
    dispatch_once(&onceToken, ^{
        items = [NSMutableArray array];
        [items addObjectsFromArray:@[UIProgressView.class, UISlider.class, UISwitch.class, UIImageView.class]];
    });
    return items;
}

+ (NSMutableArray *)languages {
    static dispatch_once_t onceToken;
    static NSMutableArray *languages = nil;
    dispatch_once(&onceToken, ^{
        languages = [NSMutableArray array];
    });
    return languages;
}

@end