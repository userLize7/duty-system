package com.demo.dutysystem.controller;

import com.demo.dutysystem.entity.Employee;
import com.demo.dutysystem.entity.EmployeeStats;
import com.demo.dutysystem.mapper.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/employee")
public class EmployeeController {

    @Autowired
    private EmployeeMapper employeeMapper;

    // 接口：查询所有员工
    @GetMapping("/list")
    public List<Employee> listAll() {
        return employeeMapper.findAll();
    }

    // 接口2：按部门查询员工
    @GetMapping("/department")
    public List<Employee> listByDepartment(@RequestParam String dept) {
        return employeeMapper.findByDepartment(dept);
    }

    // 接口3：统计每个员工的值班次数和补贴总额
    @GetMapping("/stats")
    public List<EmployeeStats> getStats() {
        return employeeMapper.getEmployeeStats();
    }

}