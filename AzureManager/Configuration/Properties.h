//
//  Properties.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

typedef enum ListTypeSelInd {
	listViewIndex = 0,
	objViewIndex
} ListTypeSelInd;

// app constants
#define MAXNUMROWS_TABLES          100
#define MAXNUMROWS_ENTITIES        20
#define MAXNUMROWS_CONTAINERS      20
#define MAXNUMROWS_BLOBS           20
#define MAXNUMROWS_QUEUES          20
#define MAXNUMROWS_QMESSAGES       100

// HARD-CODED (Temporary) ACCOUNT INFO
#define TEMP_ACCOUNTNAME        @"neudesictestvg1"
#define TEMP_ACCESSKEY          @"6PTagAWDBktbI96HQFUVHxyPMM3D/3MksJVlTNIIGKspEx4GOFAugGG3iyvdrzldbeFPftfN/pVPxdVvU+AIKw=="

#define PADDING_FOR_SELECTION_CELLS     @"       "

// notifs
