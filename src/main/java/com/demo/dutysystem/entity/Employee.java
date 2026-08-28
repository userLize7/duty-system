package com.demo.dutysystem.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Employee {
    private Integer id;
    private String empNo;
    private String name;
    private String department;
    private String phone;
    private LocalDate entryDate;
    private Integer status;
    private LocalDateTime createTime;

    // getter和setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getEmpNo() { return empNo; }
    public void setEmpNo(String empNo) { this.empNo = empNo; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public LocalDate getEntryDate() { return entryDate; }
    public void setEntryDate(LocalDate entryDate) { this.entryDate = entryDate; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
}