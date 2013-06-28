//
//  ARValidatorUniqueness.m
//  iActiveRecord
//
//  Created by Alex Denisov on 31.03.12.
//  Copyright (c) 2012 CoreInvader. All rights reserved.
//

#import "ARValidatorUniqueness.h"
#import "ARLazyFetcher.h"
#import "ARErrorHelper.h"

@implementation ARValidatorUniqueness

- (NSString *)errorMessage {
    return kARFieldAlreadyExists;
}

- (BOOL)validateField:(NSString *)aField ofRecord:(id)aRecord {
    NSString *recordName = [[aRecord class] description];
    id aValue = [aRecord valueForKey:aField];
    id aId = [aRecord valueForKey:@"id"];
    ARLazyFetcher *fetcher = [[ARLazyFetcher alloc] initWithRecord:NSClassFromString(recordName)];
    
    ARWhereStatement * ignoreSameRecord = [ARWhereStatement whereField:@"id" ofRecord:[aRecord class] notEqualToValue: aId];
    ARWhereStatement * ensureUniqueField = [ARWhereStatement whereField:aField ofRecord:[aRecord class] equalToValue: aValue];
    ARWhereStatement *finalStatement = [ARWhereStatement concatenateStatement:ignoreSameRecord withStatement:ensureUniqueField useLogicalOperation:ARLogicalAnd];
    
    [fetcher setWhereStatement:finalStatement];
    
    NSInteger count = [fetcher count];
    
    if(count > 0){
        return NO;
    }
    return YES;
}

@end
