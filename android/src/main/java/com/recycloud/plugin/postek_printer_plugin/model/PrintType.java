package com.recycloud.plugin.postek_printer_plugin.model;

public enum PrintType {
    TITLE("title"),
    SUBTITLE("subtitle"),
    TEXT("text"),
    QR("qr");

    public final String value;

    PrintType(String value){
        this.value = value;
    }

    public static PrintType fromStr(String str){
        for (PrintType type : PrintType.values()) {
            if (type.value.equals(str)){
                return type;
            }
        }
        return null;
    }
}
