#import "PrintFixedAssets.h"
#import "PTKPrintSDK.h"

@implementation PrintFixedAssets

+ (void)printWithSDK:(PTKPrintSDK *)sdk data:(NSDictionary *)data {
    int mm = 8;
    int result = 0;

    // 设置打印黑度
    result = [sdk PTKSetDarkness:16];
    if (result != PTK_SUCCESS) return;

    // 设置打印速度
    result = [sdk PTKSetPrintSpeed:1];
    if (result != PTK_SUCCESS) return;

    // 设置打印方向
    result = [sdk PTKSetDirection:'B'];
    if (result != PTK_SUCCESS) return;

    //标签纸设置 宽高等于量得的毫米数乘以换算为dots的系数 分辨率为203dpi的为8 300dpi的为12 600dpi的24
    //如203dpi分辨率的机器 标签纸高为75mm=75*8=600dots；
    
    // 设置标签高度、间隙及偏移
    result = [sdk PTKSetLabelHeight:NORMAL_GAP_MODE andHeight:80 * mm andGapH:3 andGap:3];
    if (result != PTK_SUCCESS) return;

    // 设置标签宽度
    result = [sdk PTKSetLabelWidth:100 * mm];
    if (result != PTK_SUCCESS) return;
    
    // 清空缓存
    result = [sdk PTKClearBuffer];
    if (result != PTK_SUCCESS) return;

    // 打印两组内容（y=0, y=320）
    result = [self printContent:sdk y:0];
    if (result != PTK_SUCCESS) return;
    result = [self printContent:sdk y:320];
    if (result != PTK_SUCCESS) return;

    // 打印
    result = [sdk PTKPrintLabel:1 andCPNum:1];
    if (result != PTK_SUCCESS) return;
    // 切纸
    // result = [sdk PTKCutPage:1];
    // if (result != PTK_SUCCESS) return;
//    result = [sdk PTKPrint];
//    if (result != 0) return;
    
//    [sdk PTKDrawRectangle:79 andPy:50 andThickness:2 andEx:778 andEy:554];
//    [sdk PTKDrawLineOr:78 andPy:226 andLenth:699 andH:2];
//    [sdk PTK_DrawBar2D_Pdf417:117 andY:403 andW:344 andV:84 andS:0 andC:0 andPx:4 andPy:6 andR:13 andL:1 andT:0 andO:0 andStr:@"TEL&QQ : 4006002368"];
//  
//    [sdk PTK_DrawBar2D_QR:507 andY:248 andW:0 andV:0 andO:0 andR:10 andM:4 andG:0 andS:8 andStr:@"http://www.postek.com.cn"];
//    [sdk PTKDrawText:193 andPy:122 andDirec:0 andFont:'3' andHorizontal:1 andVertical:1 andText:'N' andStr:@"金风玉露一相逢，便胜却人间无数"];
//    [sdk PTKDrawBarcode:112 andPy:251 andDirec:0 andCode:@"3" andNarrowWidth:3 andHorizontal:2 andVertital:60 andText:'N' andStr:@"83240988"];
//    [sdk PTKDrawText:208 andPy:339 andDirec:0 andFont:'4' andHorizontal:1 andVertical:1 andText:'N' andStr:@"83240988"];
//    [sdk PTKPrintLabel:1 andCPNum:1];
}

+ (int)printContent:(PTKPrintSDK *)sdk y:(int)y {
    int result = 0;
    int offset_X = 0;
    int offset_Y = 0 + y;

    // 打印标题
    result = [sdk PTKDrawText:165 + offset_X andPy:30 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"XXXXX      资产管理"];
    if (result != PTK_SUCCESS) return result;

    // 打印矩形
    result = [sdk PTKDrawRectangle:20 + offset_X andPy:20 + offset_Y andThickness:4 andEx:780 andEy:300 + offset_Y];
    if (result != PTK_SUCCESS) return result;

    // 打印线条
    result = [sdk PTKDrawLineOr:20 + offset_X andPy:76 + offset_Y andLenth:760 andH:4];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawLineOr:20 + offset_X andPy:132 + offset_Y andLenth:760 andH:4];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawLineOr:20 + offset_X andPy:188 + offset_Y andLenth:760 andH:4];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawLineOr:20 + offset_X andPy:244 + offset_Y andLenth:760 andH:4];
    if (result != PTK_SUCCESS) return result;

    // 打印文字
    result = [sdk PTKDrawText:30 + offset_X andPy:86 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"资产编号"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:150 + offset_X andPy:86 + offset_Y andDirec:0 andFont:'3' andHorizontal:1 andVertical:1 andText:'N' andStr:@"50100125"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:30 + offset_X andPy:142 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"资产名称"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:30 + offset_X andPy:198 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"规格型号"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:30 + offset_X andPy:254 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"购买日期"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:410 + offset_X andPy:86 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"存放地点"];
    if (result != PTK_SUCCESS) return result;

    // 竖线
    result = [sdk PTKDrawLineOr:140 + offset_X andPy:76 + offset_Y andLenth:4 andH:224];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawLineOr:400 + offset_X andPy:76 + offset_Y andLenth:4 andH:224];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawLineOr:520 + offset_X andPy:76 + offset_Y andLenth:4 andH:224];
    if (result != PTK_SUCCESS) return result;

    // 右侧内容
    result = [sdk PTKDrawText:150 + offset_X andPy:142 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"笔记本电脑"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:410 + offset_X andPy:142 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"使用部门"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:410 + offset_X andPy:198 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"管理人"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:410 + offset_X andPy:254 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"使用日期"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:530 + offset_X andPy:142 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"运营部"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:150 + offset_X andPy:198 + offset_Y andDirec:0 andFont:'3' andHorizontal:1 andVertical:1 andText:'N' andStr:@"MateBook D16"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:150 + offset_X andPy:254 + offset_Y andDirec:0 andFont:'3' andHorizontal:1 andVertical:1 andText:'N' andStr:@"2024-7-31"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:530 + offset_X andPy:86 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"XX办公室"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:530 + offset_X andPy:198 + offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"XXX"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:530 + offset_X andPy:254 + offset_Y andDirec:0 andFont:'3' andHorizontal:1 andVertical:1 andText:'N' andStr:@"2024-7-31"];
    if (result != PTK_SUCCESS) return result;

    return result;
}

@end 
