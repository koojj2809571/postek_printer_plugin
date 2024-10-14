package com.recycloud.plugin.postek_printer_plugin.template.impl;

import com.postek.cdfpsk.CDFPTKAndroid;
import com.recycloud.plugin.postek_printer_plugin.template.IPrintTemplate;

public class PrintFixedAssets implements IPrintTemplate {
    @Override
    public void print(CDFPTKAndroid cdf) {
        /*
         *mm:点，毫米转为点，由打印机分辨率决定
         * 打印机分辨DPI=203时， mm=8
         * 打印机分辨DPI=300时， mm=12
         * 打印机分辨DPI=600时， mm=24
         */
        int mm = 8;

        int result = 0;
        String message = "";


        /*函数返回值*/
        int result_printing = 0;
        /*横坐标偏移,设置标签整体横向移动位置*/
        int offset_X = 0;

        /*纵坐标偏移，设置标签整体纵向移动位置*/
        int offset_Y = 0;



        /*清空缓存*/
        result_printing = cdf.PTK_ClearBuffer();
        if (result_printing != 0) return;

        /*设置打印黑度 取值范围 0-20*/
        result_printing = cdf.PTK_SetDarkness(16);
        if (result_printing != 0) return;

        /*设置打印速度*/
        result_printing = cdf.PTK_SetPrintSpeed(1);
        if (result_printing != 0) return;

        /*设置打印方向*/
        result_printing = cdf.PTK_SetDirection("B");
        if (result_printing != 0) return;

        /*设置标签高度、间隙及偏移*/
        result_printing = cdf.PTK_SetLabelHeight(80 * mm, 3, 3, false);
        if (result_printing != 0) return;

        /*设置标签宽度，一定要准确，否则会导致打印内容位置不准确*/
        result_printing = cdf.PTK_SetLabelWidth(100 * mm);
        if (result_printing != 0) return;


//        cdf.PTK_DrawLineOr(400,0, 3, 640);



//        result_printing = cdf.PTK_DrawRectangle(20, 300, 3, 780, 620);
//        if (result_printing != 0) return;

        //中间分隔线
//        result_printing = cdf.PTK_DrawLineOr(0, 320, 800, 8);
//        if (result_printing != 0) return;

//        result_printing = cdf.PTK_DrawRectangle(23, 20, 4, 780, 204);
//        if (result_printing != 0) return;

        result_printing = printContent(cdf, 0);
        if (result_printing != 0) return;
        result_printing = printContent(cdf, 320);
        if (result_printing != 0) return;



        /*打印，必须要执行PTK_PrintLabel和PTK_Print，否则不会打印，打印多张标签时每张标签后面都需要加它*/
        result_printing = cdf.PTK_PrintLabel(1, 1);
        if (result_printing != 0) return;

        result_printing = cdf.PTK_Print();
        if (result_printing != 0) return;
    }

    private static int printContent(CDFPTKAndroid cdf, int y){
        int result_printing = 0;
        /*横坐标偏移,设置标签整体横向移动位置*/
        int offset_X = 0;

        /*纵坐标偏移，设置标签整体纵向移动位置*/
        int offset_Y = 0 + y;
        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(165 + offset_X), (int)(30 + offset_Y), 36, "serif",1,4,false,false,false,"N", "XXXXX      资产管理"); //中再云汇      档案资产管理
        if (result_printing != 0) { return result_printing; }

        /* 打印矩形*/
        result_printing = cdf.PTK_DrawRectangle((int)(20 + offset_X), (int)(20 + offset_Y), 4, 780, 300 + offset_Y);
        if (result_printing != 0) {return result_printing; }

        /* 打印线条*/
        result_printing = cdf.PTK_DrawLineOr((int)(20 + offset_X), (int)(76 + offset_Y), 760, 4);
        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
        result_printing = cdf.PTK_DrawLineOr((int)(20 + offset_X), (int)(132 + offset_Y), 760, 4);
        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
        result_printing = cdf.PTK_DrawLineOr((int)(20 + offset_X), (int)(188 + offset_Y), 760, 4);
        if (result_printing != 0) {  return result_printing; }


        /* 打印线条*/
        result_printing = cdf.PTK_DrawLineOr((int)(20 + offset_X), (int)(244 + offset_Y), 760, 4);
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(30 + offset_X), (int)(86 + offset_Y), 25, "serif",1,4,false,false,false,"N", "资产编号");//资产编号
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(150 + offset_X), (int)(86 + offset_Y), 25, "serif",1,4,false,false,false,"N", "50100125");//50100125
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(30 + offset_X), (int)(142 + offset_Y), 25, "serif",1,4,false,false,false,"N", "资产名称");//资产名称
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(30 + offset_X), (int)(198 + offset_Y), 25, "serif",1,4,false,false,false,"N", "规格型号");//规格型号
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(30 + offset_X), (int)(254 + offset_Y), 25, "serif",1,4,false,false,false,"N", "购买日期");//购买日期
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(410 + offset_X), (int)(86 + offset_Y), 25, "serif",1,4,false,false,false,"N","存放地点");//档案类型
        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
        result_printing = cdf.PTK_DrawLineOr((int)(140 + offset_X), (int)(76 + offset_Y), 4, 224);
        if (result_printing != 0) {  return result_printing; }

        result_printing = cdf.PTK_DrawLineOr((int)(400 + offset_X), (int)(76 + offset_Y), 4, 224);
        if (result_printing != 0) {  return result_printing; }

        result_printing = cdf.PTK_DrawLineOr((int)(520 + offset_X), (int)(76 + offset_Y), 4, 224);
        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
//        result_printing = cdf.PTK_DrawLineOr((int)(501 + offset_X), (int)(51 + offset_Y), 4, 38);
//        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(150 + offset_X), (int)(142 + offset_Y), 25, "serif",1,4,false,false,false,"N", "笔记本电脑");//笔记本电脑
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(410 + offset_X), (int)(142 + offset_Y), 25, "serif",1,4,false,false,false,"N", "使用部门");//客户号
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(410 + offset_X), (int)(198 + offset_Y), 25, "serif",1,4,false,false,false,"N", "管理人");//
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(410 + offset_X), (int)(254 + offset_Y), 25, "serif",1,4,false,false,false,"N", "使用日期");//
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(530 + offset_X), (int)(142 + offset_Y), 25, "serif",1,4,false,false,false,"N", "运营部");//2000403916
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(150 + offset_X), (int)(198 + offset_Y), 25, "serif",1,4,false,false,false,"N", "MateBook D16");//广东省深圳市XXXX有限公司
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(150 + offset_X), (int)(254 + offset_Y), 25, "serif",1,4,false,false,false,"N", "2024-7-31");//广东省深圳市分行
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(530 + offset_X), (int)(86 + offset_Y), 25, "serif",1,4,false,false,false,"N", "XX办公室");//房产抵押合同
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(530 + offset_X), (int)(198 + offset_Y), 25, "serif",1,4,false,false,false,"N", "XXX");//
        if (result_printing != 0) {  return result_printing; }

        /* 打印文字*/
        result_printing = cdf.PTK_DrawText_TrueType((int)(530 + offset_X), (int)(254 + offset_Y), 25, "serif",1,4,false,false,false,"N", "2024-7-31");//
        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
//        result_printing = cdf.PTK_DrawLineOr((int)(609 + offset_X), (int)(53 + offset_Y), 4, 36);
//        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
//        result_printing = cdf.PTK_DrawLineOr((int)(188 + offset_X), (int)(50 + offset_Y), 4, 153);
//        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
//        result_printing = cdf.PTK_DrawLineOr((int)(563 + offset_X), (int)(129 + offset_Y), 4, 75);
//        if (result_printing != 0) {  return result_printing; }

        /* 打印线条*/
//        result_printing = cdf.PTK_DrawLineOr((int)(358 + offset_X), (int)(89 + offset_Y), 4, 38);
//        if (result_printing != 0) {  return result_printing; }

        /* 打印一维码*/
//        result_printing = cdf.PTK_DrawBarcode((int)(602 + offset_X), (int)(133 + offset_Y), 0, "1", 1, 3, 39, 'N', "");//A01252951
//        if (result_printing != 0) { return result_printing; }

        /* 打印文字*/
//        result_printing = cdf.PTK_DrawText_TrueType((int)(594 + offset_X), (int)(172 + offset_Y), 25, "serif",1,4,false,false,false,"N", "");//A01252951
//        if (result_printing != 0) {  return result_printing; }

        return result_printing;
    }
}
