package com.demo.dutysystem.mapper;

import com.demo.dutysystem.entity.Employee;
import com.demo.dutysystem.entity.EmployeeStats;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface EmployeeMapper {

    // 查询所有员工
    @Select("SELECT * FROM employee")
    List<Employee> findAll();

    // 根据部门查询
    @Select("SELECT * FROM employee WHERE department = #{department}")
    List<Employee> findByDepartment(String department);

    // 统计每个员工的值班次数和补贴总额（多表联查）
    @Select("SELECT " +
            "e.name, e.department, " +
            "COUNT(s.id) AS dutyCount, " +
            "SUM(d.subsidy) AS totalSubsidy " +
            "FROM schedule s " +
            "JOIN employee e ON s.employee_id = e.id " +
            "JOIN duty d ON s.duty_id = d.id " +
            "GROUP BY s.employee_id")
    List<EmployeeStats> getEmployeeStats();


}

