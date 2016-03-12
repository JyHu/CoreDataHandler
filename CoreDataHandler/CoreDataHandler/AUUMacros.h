//
//  AUUMacros.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/12.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#ifndef AUUMacros_h
#define AUUMacros_h

#   if DEBUG

/**
 *  @author JyHu, 16-03-12 18:03:52
 *
 *  打印空的一行
 *
 *  @since v1.0
 */
#       define AUUTinyLine printf("\n");

/**
 *  @author JyHu, 16-03-12 18:03:49
 *
 *  进行Debug log的方法
 *
 *  @since v1.0
 */
#       define AUUDebugLog(format, ...)                                                             \
            do {                                                                                    \
                printf("[%s:%d] %s\n",                                                              \
                [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],          \
                __LINE__,                                                                           \
                [[NSString stringWithFormat:(format),## __VA_ARGS__] UTF8String]);                  \
            }while(0)

/**
 *  @author JyHu, 16-03-12 18:03:37
 *
 *  操作CoreData数据的operation开始的Debug log
 *
 *  @since v1.0
 */
#       define AUUDebugBeginWithInfo(format, ...)                                                   \
            do{                                                                                     \
                printf("\n"                                                                         \
                       "┌────────────────────────────────────────────────────────────┐\n"           \
                       "|            %s\n"                                                          \
                       "├────────────────────────────────────────────────────────────┤\n"           \
                       "⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥ ⥥\n",          \
                            [[NSString stringWithFormat:(format),## __VA_ARGS__] UTF8String]);      \
            }while(0)

/**
 *  @author JyHu, 16-03-12 18:03:43
 *
 *  操作CoreData数据的operation结束的Debug log
 *
 *  @since v1.0
 */
#       define AUUDebugFinishWithInfo(format, ...)                                                  \
            do {                                                                                    \
                printf("\n"                                                                         \
                       "⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣ ⥣\n"           \
                       "├────────────────────────────────────────────────────────────┤\n"           \
                       "|           %s\n"                                                           \
                       "└────────────────────────────────────────────────────────────┘\n",          \
                            [[NSString stringWithFormat:(format),## __VA_ARGS__] UTF8String]);      \
            }while(0)

#   else    // DEBUG else

#       define AUUTinyLine {}
#       define AUUDebugLog(format, ...)  {}
#       define AUUDebugBeginWithInfo(format, ...)  {}
#       define AUUDebugFinishWithInfo(format, ...) {}

#   endif   // End DEBUG

#endif /* AUUMacros_h */
