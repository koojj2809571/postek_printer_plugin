#import "PrintMaterialOrder.h"
#import "PTKPrintSDK.h"

@implementation PrintMaterialOrder

+ (void)printWithSDK:(PTKPrintSDK *)sdk data:(NSDictionary *)data {
    NSLog(@"PrintMaterialOrder");

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
    result = [self printContent:sdk y:0 data:data];
    if (result != PTK_SUCCESS) return;

    // 打印
    result = [sdk PTKPrintLabel:1 andCPNum:1];
    if (result != PTK_SUCCESS) return;
    // 切纸
    // result = [sdk PTKCutPage:1];
    // if (result != PTK_SUCCESS) return;
}

+ (int)printContent:(PTKPrintSDK *)sdk y:(int)y data:(NSDictionary *)data {
    int result = 0;
    int offset_X = 0;
    int offset_Y = 0 + y;

    // 示例字段名
    NSString *code = data[@"code"] ?: @"";
    NSString *disassembleTime = data[@"disassembleTime"] ?: @"";
    NSString *carNumber = data[@"carNumber"] ?: @"";
    NSString *brandSeries = data[@"brandSeries"] ?: @"";
    NSString *carType = data[@"carType"] ?: @"";
    NSString *vin = data[@"vin"] ?: @"";
    NSString *qrContent = data[@"qrContent"] ?: code;

    // 打印外框
    result = [sdk PTKDrawRectangle:20+offset_X andPy:20+offset_Y andThickness:4 andEx:780 andEy:620+offset_Y];
    if (result != PTK_SUCCESS) return result;

    // 打印标题（居中）
    result = [sdk PTKDrawText:300+offset_X andPy:40+offset_Y andDirec:0 andFont:'6' andHorizontal:2 andVertical:2 andText:'N' andStr:@"发动机总成"];
    if (result != PTK_SUCCESS) return result;

    // 打印字段内容
    int leftX = 120 + offset_X;
    int valueX = 340 + offset_X;
    // int lineH = 50;
    int startY = 120 + offset_Y;
    int gapY = 40;
    int idx = 0;

    // 回用件编码
    result = [sdk PTKDrawText:leftX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"回用件编码:"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:valueX andPy:startY+idx*gapY andDirec:0 andFont:'3' andHorizontal:1 andVertical:1 andText:'N' andStr:code];
    if (result != PTK_SUCCESS) return result;
    idx++;
    // 拆解时间
    result = [sdk PTKDrawText:leftX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"拆解时间:"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:valueX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:disassembleTime];
    if (result != PTK_SUCCESS) return result;
    idx++;
    // 报废车辆号
    result = [sdk PTKDrawText:leftX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"报废车辆号:"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:valueX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:carNumber];
    if (result != PTK_SUCCESS) return result;
    idx++;
    // 报废品牌车系
    result = [sdk PTKDrawText:leftX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"报废品牌车系:"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:valueX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:brandSeries];
    if (result != PTK_SUCCESS) return result;
    idx++;
    // 报废车型
    result = [sdk PTKDrawText:leftX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"报废车型:"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:valueX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:carType];
    if (result != PTK_SUCCESS) return result;
    idx++;
    // 车辆VIN码
    result = [sdk PTKDrawText:leftX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"车辆VIN码:"];
    if (result != PTK_SUCCESS) return result;
    result = [sdk PTKDrawText:valueX andPy:startY+idx*gapY andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:vin];
    if (result != PTK_SUCCESS) return result;

    // 打印二维码
    int qrX = 120 + offset_X;
    int qrY = 380 + offset_Y;
    result = [sdk PTK_DrawBar2D_QR:qrX andY:qrY andW:80 andV:0 andO:0 andR:8 andM:4 andG:0 andS:8 andStr:qrContent];
    if (result != PTK_SUCCESS) return result;

    // 打印提示
    result = [sdk PTKDrawText:350+offset_X andPy:500+offset_Y andDirec:0 andFont:'6' andHorizontal:1 andVertical:1 andText:'N' andStr:@"扫一扫查看回用件详情"];
    if (result != PTK_SUCCESS) return result;

    return PTK_SUCCESS;
}
@end
