-- ============================================
-- 数据库名称：duty_system
-- 说明：企业值班排班统计系统
-- ============================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `duty_system`
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 切换到该数据库
USE `duty_system`;

-- ============================================
-- 1. 员工表（employee）
-- ============================================
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
                            `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `emp_no` VARCHAR(20) NOT NULL COMMENT '工号（唯一）',
                            `name` VARCHAR(50) NOT NULL COMMENT '姓名',
                            `department` VARCHAR(100) NOT NULL COMMENT '部门',
                            `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
                            `entry_date` DATE NOT NULL COMMENT '入职日期',
                            `status` TINYINT DEFAULT 1 COMMENT '状态：1在职 0离职',
                            `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `uk_emp_no` (`emp_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工表';

-- ============================================
-- 2. 值班表（duty）
-- ============================================
DROP TABLE IF EXISTS `duty`;
CREATE TABLE `duty` (
                        `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                        `duty_name` VARCHAR(50) NOT NULL COMMENT '班次名称（如：白班/夜班/节假日值班）',
                        `start_time` TIME NOT NULL COMMENT '开始时间',
                        `end_time` TIME NOT NULL COMMENT '结束时间',
                        `subsidy` DECIMAL(10,2) DEFAULT 0.00 COMMENT '补贴金额（元/次）',
                        `duty_type` TINYINT DEFAULT 1 COMMENT '类型：1工作日 2周末 3节假日',
                        `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='值班表';

-- ============================================
-- 3. 排班记录表（schedule）⭐核心中间表
-- ============================================
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
                            `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `employee_id` INT NOT NULL COMMENT '员工ID（外键→employee.id）',
                            `duty_id` INT NOT NULL COMMENT '值班ID（外键→duty.id）',
                            `schedule_date` DATE NOT NULL COMMENT '排班日期',
                            `attendance_status` TINYINT DEFAULT 1 COMMENT '到岗状态：1正常 2迟到 3缺勤 4请假',
                            `remark` VARCHAR(255) DEFAULT NULL COMMENT '备注（如：调班说明）',
                            `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            PRIMARY KEY (`id`),
                            KEY `idx_employee_id` (`employee_id`),
                            KEY `idx_duty_id` (`duty_id`),
                            KEY `idx_schedule_date` (`schedule_date`),
                            CONSTRAINT `fk_schedule_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE,
                            CONSTRAINT `fk_schedule_duty` FOREIGN KEY (`duty_id`) REFERENCES `duty` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排班记录表';

-- ============================================
-- 4. 插入测试数据
-- ============================================

-- 4.1 插入员工数据
INSERT INTO `employee` (`emp_no`, `name`, `department`, `phone`, `entry_date`, `status`) VALUES
                                                                                             ('E001', '张三', '技术部', '13800000001', '2023-03-01', 1),
                                                                                             ('E002', '李四', '技术部', '13800000002', '2023-06-15', 1),
                                                                                             ('E003', '王五', '财务部', '13800000003', '2024-01-10', 1),
                                                                                             ('E004', '赵六', '行政部', '13800000004', '2024-05-20', 1),
                                                                                             ('E005', '孙七', '行政部', '13800000005', '2024-08-01', 1);

-- 4.2 插入值班班次数据
INSERT INTO `duty` (`duty_name`, `start_time`, `end_time`, `subsidy`, `duty_type`) VALUES
                                                                                       ('白班', '08:00:00', '16:00:00', 0.00, 1),
                                                                                       ('夜班', '16:00:00', '22:00:00', 50.00, 1),
                                                                                       ('周末白班', '08:00:00', '16:00:00', 80.00, 2),
                                                                                       ('周末夜班', '16:00:00', '22:00:00', 120.00, 2),
                                                                                       ('节假日值班', '08:00:00', '20:00:00', 200.00, 3);

-- 4.3 插入排班记录数据
INSERT INTO `schedule` (`employee_id`, `duty_id`, `schedule_date`, `attendance_status`) VALUES
                                                                                            (1, 1, '2026-08-03', 1),
                                                                                            (1, 2, '2026-08-04', 1),
                                                                                            (2, 1, '2026-08-03', 2),
                                                                                            (2, 3, '2026-08-10', 1),
                                                                                            (3, 5, '2026-08-01', 1),
                                                                                            (3, 1, '2026-08-05', 3),
                                                                                            (4, 1, '2026-08-03', 1),
                                                                                            (4, 4, '2026-08-17', 1),
                                                                                            (5, 1, '2026-08-03', 1),
                                                                                            (5, 2, '2026-08-18', 4);

-- ============================================
-- 5. 核心统计SQL（面试高频考题）
-- ============================================

-- 5.1 统计每个员工的值班次数和补贴总额
SELECT
    e.name,
    e.department,
    COUNT(s.id) AS duty_count,
    IFNULL(SUM(d.subsidy), 0) AS total_subsidy
FROM employee e
         LEFT JOIN schedule s ON s.employee_id = e.id
         LEFT JOIN duty d ON s.duty_id = d.id
GROUP BY e.id
ORDER BY total_subsidy DESC;

-- 5.2 统计各部门的缺勤率
SELECT
    e.department,
    COUNT(s.id) AS total_duty,
    SUM(CASE WHEN s.attendance_status = 3 THEN 1 ELSE 0 END) AS absence_count,
    ROUND(SUM(CASE WHEN s.attendance_status = 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(s.id), 2) AS absence_rate
FROM schedule s
         JOIN employee e ON s.employee_id = e.id
GROUP BY e.department
ORDER BY absence_rate DESC;