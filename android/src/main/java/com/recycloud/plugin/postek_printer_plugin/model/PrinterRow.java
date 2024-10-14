package com.recycloud.plugin.postek_printer_plugin.model;

public class PrinterRow {
    private String label;
    private String value;
    private String type;

    public PrintType type(){
        return PrintType.fromStr(type);
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "PrinterRow{" +
                "label='" + label + '\'' +
                ", value='" + value + '\'' +
                ", type='" + type + '\'' +
                '}';
    }
}
