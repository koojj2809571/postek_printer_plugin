package com.recycloud.plugin.postek_printer_plugin.template.impl;

import com.postek.cdfpsk.CDFPTKAndroid;
import com.recycloud.plugin.postek_printer_plugin.template.IPrintTemplate;
import java.util.Map;

public class PrintMaterialOrder implements IPrintTemplate {
    private Map<String, String> data;

    public PrintMaterialOrder(Map<String, String> data) {
        this.data = data;
    }

    @Override
    public void print(CDFPTKAndroid cdf) {
        int mm = 8;
        int result = 0;
        int result_printing = 0;
        int offset_X = 0;
        int offset_Y = 0;

        // 清空缓存
        result_printing = cdf.PTK_ClearBuffer();
        if (result_printing != 0) return;

        // 设置打印黑度
        result_printing = cdf.PTK_SetDarkness(16);
        if (result_printing != 0) return;

        // 设置打印速度
        result_printing = cdf.PTK_SetPrintSpeed(1);
        if (result_printing != 0) return;

        // 设置打印方向
        result_printing = cdf.PTK_SetDirection("B");
        if (result_printing != 0) return;

        // 设置标签高度、间隙及偏移
        result_printing = cdf.PTK_SetLabelHeight(80 * mm, 3, 3, false);
        if (result_printing != 0) return;

        // 设置标签宽度
        result_printing = cdf.PTK_SetLabelWidth(100 * mm);
        if (result_printing != 0) return;

        // 打印内容
        result_printing = printContent(cdf, 0, data);
        if (result_printing != 0) return;

        // 打印
        result_printing = cdf.PTK_PrintLabel(1, 1);
        if (result_printing != 0) return;
        result_printing = cdf.PTK_Print();
    }

    private static int printContent(CDFPTKAndroid cdf, int y, Map<String, String> data) {
        int result_printing = 0;
        int offset_X = 0;
        int offset_Y = 0 + y;

        // 为了兼容性更好，避免使用 Java 8 的 Map.getOrDefault，可以这样写：
        String code = data != null && data.containsKey("code") ? data.get("code") : "";
        String disassembleTime = data != null && data.containsKey("disassembleTime") ? data.get("disassembleTime") : "";
        String carNumber = data != null && data.containsKey("carNumber") ? data.get("carNumber") : "";
        String brandSeries = data != null && data.containsKey("brandSeries") ? data.get("brandSeries") : "";
        String carType = data != null && data.containsKey("carType") ? data.get("carType") : "";
        String vin = data != null && data.containsKey("vin") ? data.get("vin") : "";
        String qrContent = data != null && data.containsKey("qrContent") ? data.get("qrContent") : code;

        // 打印外框
        result_printing = cdf.PTK_DrawRectangle((int)(20 + offset_X), (int)(20 + offset_Y), 4, 780, 620 + offset_Y);
        if (result_printing != 0) return result_printing;

        // 打印标题
        result_printing = cdf.PTK_DrawText_TrueType((int)(300 + offset_X), (int)(40 + offset_Y), 40, "serif", 1, 1, false, false, false, "N", "发动机总成");
        if (result_printing != 0) return result_printing;

        int leftX = 120 + offset_X;
        int valueX = 340 + offset_X;
        int startY = 120 + offset_Y;
        int gapY = 40;
        int idx = 0;

        // 回用件编码
        result_printing = cdf.PTK_DrawText_TrueType((int)(leftX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", "回用件编码:");
        if (result_printing != 0) return result_printing;
        result_printing = cdf.PTK_DrawText_TrueType((int)(valueX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", code);
        if (result_printing != 0) return result_printing;
        idx++;
        // 拆解时间
        result_printing = cdf.PTK_DrawText_TrueType((int)(leftX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", "拆解时间:");
        if (result_printing != 0) return result_printing;
        result_printing = cdf.PTK_DrawText_TrueType((int)(valueX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", disassembleTime);
        if (result_printing != 0) return result_printing;
        idx++;
        // 报废车辆号
        result_printing = cdf.PTK_DrawText_TrueType((int)(leftX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", "报废车辆号:");
        if (result_printing != 0) return result_printing;
        result_printing = cdf.PTK_DrawText_TrueType((int)(valueX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", carNumber);
        if (result_printing != 0) return result_printing;
        idx++;
        // 报废品牌车系
        result_printing = cdf.PTK_DrawText_TrueType((int)(leftX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", "报废品牌车系:");
        if (result_printing != 0) return result_printing;
        result_printing = cdf.PTK_DrawText_TrueType((int)(valueX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", brandSeries);
        if (result_printing != 0) return result_printing;
        idx++;
        // 报废车型
        result_printing = cdf.PTK_DrawText_TrueType((int)(leftX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", "报废车型:");
        if (result_printing != 0) return result_printing;
        result_printing = cdf.PTK_DrawText_TrueType((int)(valueX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", carType);
        if (result_printing != 0) return result_printing;
        idx++;
        // 车辆VIN码
        result_printing = cdf.PTK_DrawText_TrueType((int)(leftX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", "车辆VIN码:");
        if (result_printing != 0) return result_printing;
        result_printing = cdf.PTK_DrawText_TrueType((int)(valueX), (int)(startY + idx * gapY), 24, "serif", 1, 4, false, false, false, "N", vin);
        if (result_printing != 0) return result_printing;

        // 打印二维码（假设有二维码API，参数可调整）
        int qrX = 120 + offset_X;
        int qrY = 380 + offset_Y;
        cdf.PTK_DrawBar2D_QR(qrX, qrY, 80, 0, 0, 8, 4, 0, 8, qrContent);

        // 打印提示
        result_printing = cdf.PTK_DrawText_TrueType((int)(350 + offset_X), (int)(500 + offset_Y), 24, "serif", 1, 4, false, false, false, "N", "扫一扫查看回用件详情");
        if (result_printing != 0) return result_printing;

        return 0;
    }
}
