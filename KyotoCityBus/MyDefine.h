//
//  MyDefine.h
//  KyotoCityBus
//
//  Created by 武村 健二 on H28/04/03.
//  Copyright © 平成28年 wHITEgODDESS. All rights reserved.
//

#ifndef MyDefine_h
#define MyDefine_h

#define DEBUG 1

#ifdef DEBUG
#define LOG(fmt,...) NSLog((@"%s %d "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...) 
#endif 

#endif /* MyDefine_h */
