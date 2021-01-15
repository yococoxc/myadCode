//
//  ViewController.m
//  myadCode
//
//  Created by muzico on 2021/1/14.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    {
        /**
         数据来源
         中国省市区编码对照表 2020版
         https://www.b910.cn/tool/1.htm
         */
        
       NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/test2.txt"];
       
       NSString *tempString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
       if (tempString == nil) {
           return;
       }
        
        NSArray *array = [tempString componentsSeparatedByString:@"\n"];
        if ([array isKindOfClass:[NSArray class]] == NO || [array count] == 0) {
            return;
        }
        
        NSMutableArray *targetArray = [NSMutableArray array];
        for (NSString *string in array) {
            NSArray *tempArray = [string componentsSeparatedByString:@" "];
            if ([tempArray isKindOfClass:[NSArray class]] && [tempArray count] > 1) {
                NSMutableArray *keepArray = [NSMutableArray array];
                for (NSString *tempString in tempArray) {
                    if ([tempString isKindOfClass:[NSString class]] && [tempString length] > 0) {
                        [keepArray addObject:tempString];
                    }
                }
                
                if ([keepArray count] == 2) {
                    NSArray *tempArray2 = [[keepArray objectAtIndex:1] componentsSeparatedByString:@","];
                    [targetArray addObject:[NSString stringWithFormat:@"%@ %@",[keepArray objectAtIndex:0], [tempArray2 lastObject]]];
                }
            }
        }
        
        [self parseArray:targetArray];
    }
    
    
    
    return;
    {
        /**
         数据来源
         2020年中华人民共和国行政区划代码
         http://www.mca.gov.cn/article/sj/xzqh/2020/
         */
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/test.txt"];
        
        NSString *tempString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (tempString == nil) {
            return;
        }
        
        
        NSArray *array = [tempString componentsSeparatedByString:@"\n"];
        if ([array isKindOfClass:[NSArray class]] == NO || [array count] == 0) {
            return;
        }
        
        [self parseArray:array];
    }
}


- (void) parseArray:(NSArray *)array {
    if ([array isKindOfClass:[NSArray class]] == NO || [array count] == 0) {
        return;
    }
    
    
    NSMutableArray *sumKeepArray = [NSMutableArray array];
    for (NSString *temp in array) {
        NSMutableArray *tempKeepArray = [NSMutableArray array];
        NSArray *tempArray = [temp componentsSeparatedByString:@" "];
        for (NSString *tempString in tempArray) {
            if ([tempString isKindOfClass:[NSString class]] && [tempString length] > 0) {
                [tempKeepArray addObject:tempString];
            }
        }
        if ([tempKeepArray count] == 2) {
            [sumKeepArray addObject:tempKeepArray];
        }
    }
//    NSLog(@"%@",sumKeepArray);
    
    
    NSMutableArray *targetKeepArray = [NSMutableArray array];
    
    for (NSArray *array in sumKeepArray) {
        NSString *code = [array objectAtIndex:0];
        NSString *name = [array objectAtIndex:1];
        
        if ([code isKindOfClass:[NSString class]] && [code length] == 6) {
            NSRange range1 = NSMakeRange(0, 2);
            NSString *level1 = [code substringWithRange:range1];
            
            NSRange range2 = NSMakeRange(2, 2);
            NSString *level2 = [code substringWithRange:range2];
            
            NSRange range3 = NSMakeRange(4, 2);
            NSString *level3 = [code substringWithRange:range3];
            
            if ([level2 isEqualToString:@"00"] && [level2 isEqualToString:@"00"]) {
//                NSLog(@"这是一级");
                if ([targetKeepArray count] == 0) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:name forKey:@"name"];
                    [dic setObject:code forKey:@"code"];
                    [dic setObject:[NSMutableArray array] forKey:@"sub"];
                    [targetKeepArray addObject:dic];
                } else {
                    BOOL isExeit = NO;
                    
                    for (NSMutableDictionary *dic in targetKeepArray) {
                        NSString *tempCode = [dic objectForKey:@"code"];
                        if ([tempCode isKindOfClass:[NSString class]] && [tempCode isEqualToString:code]) {
                            isExeit = YES;
                        }
                    }
                    
                    if (isExeit == NO) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:name forKey:@"name"];
                        [dic setObject:code forKey:@"code"];
                        [dic setObject:[NSMutableArray array] forKey:@"sub"];
                        [targetKeepArray addObject:dic];
                    }
                }
            } else {
                if ([level3 isEqualToString:@"00"]) {
//                    NSLog(@"这是二级");
                    NSString *theLevel1 = [NSString stringWithFormat:@"%@0000",level1];
                    
                    NSMutableDictionary *level1dic = nil;
                    for (NSMutableDictionary *tempDic in targetKeepArray) {
                        NSString *tempCode = [tempDic objectForKey:@"code"];
                        if ([tempCode isKindOfClass:[NSString class]] && [tempCode isEqualToString:theLevel1]) {
                            level1dic = tempDic;
                            break;
                        }
                    }
                    
                    if ([level1dic isKindOfClass:[NSMutableDictionary class]]) {
                        NSMutableArray *sub = [level1dic objectForKey:@"sub"];
                        if ([sub isKindOfClass:[NSMutableArray class]]) {
                            if ([sub count] == 0) {
                                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                                [tempDic setObject:name forKey:@"name"];
                                [tempDic setObject:code forKey:@"code"];
                                [tempDic setObject:[NSMutableArray array] forKey:@"sub"];
                                [sub addObject:tempDic];
                            } else {
                                BOOL isExeit = NO;
                                
                                for (NSMutableDictionary *tempDic in sub) {
                                    NSString *tempCode = [tempDic objectForKey:@"code"];
                                    if ([tempCode isKindOfClass:[NSString class]] && [tempCode isEqualToString:code]) {
                                        isExeit = YES;
                                    }
                                }
                                
                                if (isExeit == NO) {
                                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                    [dic setObject:name forKey:@"name"];
                                    [dic setObject:code forKey:@"code"];
                                    [dic setObject:[NSMutableArray array] forKey:@"sub"];
                                    [sub addObject:dic];
                                }
                            }
                        }
                    }
                } else {
//                    NSLog(@"这是二级 或者 三级 ------------------------------------------  start");
                    
                    NSString *theLevel1 = [NSString stringWithFormat:@"%@0000",level1];
                    
                    NSMutableDictionary *level1dic = nil;
                    for (NSMutableDictionary *tempDic in targetKeepArray) {
                        NSString *tempCode = [tempDic objectForKey:@"code"];
                        if ([tempCode isKindOfClass:[NSString class]] && [tempCode isEqualToString:theLevel1]) {
                            level1dic = tempDic;
                            break;
                        }
                    }
                    
                    NSString *theLevel2 = [NSString stringWithFormat:@"%@%@00",level1,level2];
                    NSMutableArray *level1sub = [level1dic objectForKey:@"sub"];
                    
                    NSMutableDictionary *level2dic = nil;
                    
                    if ([level1sub isKindOfClass:[NSMutableArray class]]) {
                        BOOL theLevel2Exist = NO;
                        for (NSMutableDictionary *tempLevel2dic in level1sub) {
                            if ([tempLevel2dic isKindOfClass:[NSMutableDictionary class]]) {
                                NSString *level2dicCode = [tempLevel2dic objectForKey:@"code"];
                                if ([level2dicCode isKindOfClass:[NSString class]]) {
                                    if ([level2dicCode isEqualToString:theLevel2]) {
                                        theLevel2Exist = YES;
                                        level2dic = tempLevel2dic;
                                        break;
                                    }
                                }
                            }
                        }
                        
                        if (theLevel2Exist == NO) {
//                            NSLog(@"这是二级");
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            [dic setObject:name forKey:@"name"];
                            [dic setObject:code forKey:@"code"];
                            [dic setObject:[NSMutableArray array] forKey:@"sub"];
                            [level1sub addObject:dic];
                        } else {
//                            NSLog(@"这是三级");
                            
                            if ([level2dic isKindOfClass:[NSMutableDictionary class]]) {
                                NSMutableArray *level2sub = [level2dic objectForKey:@"sub"];
                                
                                if ([level2sub isKindOfClass:[NSMutableArray class]]) {
                                    if ([level2sub count] == 0) {
                                        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                                        [tempDic setObject:name forKey:@"name"];
                                        [tempDic setObject:code forKey:@"code"];
                                        [tempDic setObject:[NSMutableArray array] forKey:@"sub"];
                                        [level2sub addObject:tempDic];
                                    } else {
                                        BOOL isExeit = NO;
                                        
                                        for (NSMutableDictionary *tempDic in level2sub) {
                                            NSString *tempCode = [tempDic objectForKey:@"code"];
                                            if ([tempCode isKindOfClass:[NSString class]] && [tempCode isEqualToString:code]) {
                                                isExeit = YES;
                                            }
                                        }
                                        
                                        if (isExeit == NO) {
                                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                            [dic setObject:name forKey:@"name"];
                                            [dic setObject:code forKey:@"code"];
                                            [dic setObject:[NSMutableArray array] forKey:@"sub"];
                                            [level2sub addObject:dic];
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
//                    NSLog(@"这是二级 或者 三级 ------------------------------------------  end");
                }
            }
        }
    }
    
//    NSLog(@"targetKeepArray ===>>> %@",targetKeepArray);
    
    
    //排除空数组
    [targetKeepArray enumerateObjectsUsingBlock:^(NSMutableDictionary *level1Obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([level1Obj isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableArray *level1sub = [level1Obj objectForKey:@"sub"];
            if ([level1sub isKindOfClass:[NSMutableArray class]]) {
                if ([level1sub count] == 0) {
                    [level1Obj removeObjectForKey:@"sub"];
                } else {
                    [level1sub enumerateObjectsUsingBlock:^(NSMutableDictionary *level2Obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([level2Obj isKindOfClass:[NSMutableDictionary class]]) {
                            NSMutableArray *level2sub = [level2Obj objectForKey:@"sub"];
                            if ([level2sub isKindOfClass:[NSMutableArray class]]) {
                                if ([level2sub count] == 0) {
                                    [level2Obj removeObjectForKey:@"sub"];
                                } else {
                                    [level2sub enumerateObjectsUsingBlock:^(NSMutableDictionary *level3Obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if ([level3Obj isKindOfClass:[NSMutableDictionary class]]) {
                                            NSMutableArray *level3sub = [level3Obj objectForKey:@"sub"];
                                            if ([level3sub isKindOfClass:[NSMutableArray class]]) {
                                                if ([level3sub count] == 0) {
                                                    [level3Obj removeObjectForKey:@"sub"];
                                                }
                                            }
                                        }
                                    }];
                                }
                            }
                        }
                    }];
                }
            }
        }
    }];
    
    
    /**
     加入区号信息                 start
     */
    
    {
        
       NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/test3.txt"];
       NSString *tempString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
       if (tempString) {
           NSArray *array = [tempString componentsSeparatedByString:@"\n"];
           if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
               NSMutableArray *theKeepArray = [NSMutableArray array];
               for (NSString *string in array) {
                   if ([string isKindOfClass:[NSString class]]) {
                       if ([string length] > 0) {
                           NSArray *arr = [string componentsSeparatedByString:@" "];
                           if ([arr count] >= 2) {
                               NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                               [dic setObject:[arr firstObject] forKey:@"name"];
                               [dic setObject:[arr lastObject] forKey:@"code"];
                               [theKeepArray addObject:dic];
                           }
                       }
                   }
               }
               
               if ([theKeepArray count] > 0) {
                   for (NSDictionary *areaDic in theKeepArray) {
                       NSString *areaName = [areaDic objectForKey:@"name"];
                       areaName = [areaName stringByReplacingOccurrencesOfString:@"市" withString:@""];
                       
                       if ([areaName isKindOfClass:[NSString class]] && [areaName length] > 0) {
                           
                           for (NSMutableDictionary *level1dic in targetKeepArray) {
                               if ([level1dic isKindOfClass:[NSMutableDictionary class]]) {
                                   NSString *level1name = [level1dic objectForKey:@"name"];
                                   level1name = [level1name stringByReplacingOccurrencesOfString:@"" withString:@""];
                                   level1name = [level1name stringByReplacingOccurrencesOfString:@"特别行政区" withString:@""];
                                   level1name = [level1name stringByReplacingOccurrencesOfString:@"市" withString:@""];
                                   if ([level1name isKindOfClass:[NSString class]] && [level1name length] > 0 && [level1name isEqualToString:areaName]) {
                                       [level1dic setObject:[areaDic objectForKey:@"code"] forKey:@"citycode"];
                                       break;
                                   } else {
                                       NSArray *level1sub = [level1dic objectForKey:@"sub"];
                                       if ([level1sub isKindOfClass:[NSArray class]] && [level1sub count] > 0) {
                                           
                                           for (NSMutableDictionary *level2dic in level1sub) {
                                               if ([level2dic isKindOfClass:[NSMutableDictionary class]]) {
                                                   NSString *level2name = [level2dic objectForKey:@"name"];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"市" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"特别行政区" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"傣族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"白族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"回族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"蒙古自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"哈尼族彝族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"彝族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"布依族苗族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"苗族侗族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"土家族苗族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"朝鲜族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"蒙古族藏族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"藏族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"地区" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"哈萨克自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"壮族苗族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"傣族景颇族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"傈僳族自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"柯尔克孜自治州" withString:@""];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"藏族羌族自治州" withString:@""];
                                                   
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"阿拉善盟" withString:@"阿拉善"];
                                                   level2name = [level2name stringByReplacingOccurrencesOfString:@"锡林郭勒盟" withString:@"锡林郭勒"];
                                                   
                                                   
                                                   if ([level2name isKindOfClass:[NSString class]] && [level2name length] > 0 && [level2name isEqualToString:areaName]) {
                                                       [level2dic setObject:[areaDic objectForKey:@"code"] forKey:@"citycode"];
                                                       break;
                                                   } else {
                                                       /*
                                                       NSArray *level2sub = [level2dic objectForKey:@"sub"];
                                                       if ([level2sub isKindOfClass:[NSArray class]] && [level2sub count] > 0) {
                                                           
                                                           for (NSMutableDictionary *level3dic in level2sub) {
                                                               if ([level3dic isKindOfClass:[NSMutableDictionary class]]) {
                                                                   NSString *level3name = [level3dic objectForKey:@"name"];
                                                                   level3name = [level3name stringByReplacingOccurrencesOfString:@"" withString:@""];
                                                                   level3name = [level3name stringByReplacingOccurrencesOfString:@"特别行政区" withString:@""];
                                                                   if ([level3name isKindOfClass:[NSString class]] && [level3name length] > 0 && [level3name isEqualToString:areaName]) {
                                                                       [level3dic setObject:[areaDic objectForKey:@"code"] forKey:@"citycode"];
                                                                       break;
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       */
                                                   }
                                               }
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   }
               }
           }
       }
    }
    
    
    
    for (NSDictionary *level1dic in targetKeepArray) {
        NSArray *level1sub = [level1dic objectForKey:@"sub"];
        if ([level1sub isKindOfClass:[NSArray class]]) {
            for (NSDictionary *level2dic in level1sub) {
                NSArray *level2sub = [level2dic objectForKey:@"sub"];
                if ([level2sub isKindOfClass:[NSArray class]]) {
                    
                } else {
                    NSString *citycode = [level2dic objectForKey:@"citycode"];
                    if (citycode == nil) {
                        NSLog(@">>> %@",[level2dic objectForKey:@"name"]);
                    }
                }
            }
        } else {
            NSString *citycode = [level1dic objectForKey:@"citycode"];
            if (citycode == nil) {
                NSLog(@">>> %@",[level1dic objectForKey:@"name"]);
            }
        }
    }
    
    
    /**
     加入区号信息                 end
     */
    
    
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"documentPath: %@",documentPath);
    
    NSString *filePath = [documentPath stringByAppendingString:@"/test.plist"];
    [targetKeepArray writeToFile:filePath atomically:YES];
    NSString *filePath2 = [documentPath stringByAppendingString:@"/json.txt"];
    [[self toJSONData:targetKeepArray] writeToFile:filePath2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


- (NSString *)toJSONData:(id)theData{
    NSString * jsonString = @"";
    if (theData != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
 
        if ([jsonData length] != 0){
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return jsonString;
}

@end
