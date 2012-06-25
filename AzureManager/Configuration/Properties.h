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

#define SELECTED_YES_CELL_IMAGE     [UIImage imageNamed:@"IsSelected.png"]
#define SELECTED_NO_CELL_IMAGE      [UIImage imageNamed:@"NotSelected.png"]

// Azure Management properties
#define TYPE_LIST_HOSTED_SERVICES           @"TYPE_LIST_HOSTED_SERVICES"
#define TYPE_GET_BLOB_PROPERTIES            @"TYPE_GET_BLOB_PROPERTIES"
#define TYPE_SET_BLOB_SERVICE_PROPERTIES    @"TYPE_SET_BLOB_SERVICE_PROPERTIES"
#define TYPE_GET_TABLE_PROPERTIES           @"TYPE_GET_TABLE_PROPERTIES"

#define X_MS_VERSION_DATE           @"2012-06-12"

// notifs
