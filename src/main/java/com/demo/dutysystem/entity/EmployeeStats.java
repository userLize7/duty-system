package com.demo.dutysystem.entity;

public class EmployeeStats {
    private String name;
    private String department;
    private Integer dutyCount;
    private Double totalSubsidy;

    // 构造方法（MyBatis映射需要）
    public EmployeeStats(String name, String department, Integer dutyCount, Double totalSubsidy) {
        this.name = name;
        this.department = department;
        this.dutyCount = dutyCount;
        this.totalSubsidy = totalSubsidy;
    }

    // getter和setter方法
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public Integer getDutyCount() { return dutyCount; }
    public void setDutyCount(Integer dutyCount) { this.dutyCount = dutyCount; }
    public Double getTotalSubsidy() { return totalSubsidy; }
    public void setTotalSubsidy(Double totalSubsidy) { this.totalSubsidy = totalSubsidy; }
}