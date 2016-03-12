//
//  AUUMacros.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/12.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#ifndef AUUMacros_h
#define AUUMacros_h

#define AUUTinyLine printf("\n");

#define AUUDebugLog(format, ...)                                                            \
    do {                                                                                    \
        printf("[%s:%d] %s\n",                                                              \
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],          \
        __LINE__,                                                                           \
        [[NSString stringWithFormat:(format),## __VA_ARGS__] UTF8String]);                  \
    }while(0)


#define AUUDebugBeginWithInfo(format, ...)                                                  \
    do{                                                                                     \
        printf("\n"                                                                         \
               "┌────────────────────────────────────────────────────────────┐\n"           \
               "|            %s\n"                                                          \
               "├────────────────────────────────────────────────────────────┤\n"           \
               "⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥\n",          \
                    [[NSString stringWithFormat:(format),## __VA_ARGS__] UTF8String]);      \
    }while(0)

#define AUUDebugFinishWithInfo(format, ...)                                                 \
    do {                                                                                    \
        printf("\n"                                                                         \
               "⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣\n"           \
               "├────────────────────────────────────────────────────────────┤\n"           \
               "|           %s\n"                                                           \
               "└────────────────────────────────────────────────────────────┘\n",          \
                    [[NSString stringWithFormat:(format),## __VA_ARGS__] UTF8String]);      \
    }while(0)

#endif /* AUUMacros_h */
