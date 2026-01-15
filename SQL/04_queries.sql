/* =========================================================
   MEDICAL LAB ANALYTICS – ANALYTICAL QUERIES
   Author : Akash P L
   ========================================================= */

------------------------------------------------------------
-- 1. View All Orders with Test Results
------------------------------------------------------------
SELECT 
    o.order_id,
    p.patient_name,
    mt.test_name,
    tr.result_status
FROM test_orders o
JOIN patients p ON o.patient_id = p.patient_id
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN medical_tests mt ON tod.test_id = mt.test_id
LEFT JOIN test_results tr ON tod.order_detail_id = tr.order_detail_id
ORDER BY o.order_id;


------------------------------------------------------------
-- 2. Monthly Revenue Trend
------------------------------------------------------------
SELECT 
    FORMAT(payment_date, 'yyyy-MM') AS revenue_month,
    SUM(amount) AS monthly_revenue
FROM payments
GROUP BY FORMAT(payment_date, 'yyyy-MM')
ORDER BY revenue_month;


------------------------------------------------------------
-- 3. Revenue by Branch (Ranking)
------------------------------------------------------------
SELECT
    lb.branch_name,
    SUM(p.amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS branch_rank
FROM lab_branches lb
JOIN test_orders o ON lb.branch_id = o.branch_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY lb.branch_name;


------------------------------------------------------------
-- 4. Most Frequently Ordered Tests
------------------------------------------------------------
SELECT
    mt.test_name,
    COUNT(*) AS order_count
FROM test_order_details tod
JOIN medical_tests mt ON tod.test_id = mt.test_id
GROUP BY mt.test_name
ORDER BY order_count DESC;


------------------------------------------------------------
-- 5. Orders with Pending Payment
------------------------------------------------------------
SELECT
    o.order_id,
    p.patient_name,
    SUM(mt.cost) AS total_cost,
    ISNULL(SUM(pay.amount),0) AS paid_amount,
    SUM(mt.cost) - ISNULL(SUM(pay.amount),0) AS pending_amount
FROM test_orders o
JOIN patients p ON o.patient_id = p.patient_id
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN medical_tests mt ON tod.test_id = mt.test_id
LEFT JOIN payments pay ON o.order_id = pay.order_id
GROUP BY o.order_id, p.patient_name
HAVING SUM(mt.cost) > ISNULL(SUM(pay.amount),0);


------------------------------------------------------------
-- 6. Technician Productivity
------------------------------------------------------------
SELECT
    t.technician_name,
    COUNT(tp.processing_id) AS tests_processed,
    RANK() OVER (ORDER BY COUNT(tp.processing_id) DESC) AS technician_rank
FROM technicians t
JOIN test_processing tp ON t.technician_id = tp.technician_id
GROUP BY t.technician_name;


------------------------------------------------------------
-- 7. Abnormal Test Percentage by Test
------------------------------------------------------------
SELECT
    mt.test_name,
    COUNT(*) AS total_tests,
    SUM(CASE WHEN tr.result_status = 'Abnormal' THEN 1 ELSE 0 END) AS abnormal_tests,
    CAST(
        100.0 * SUM(CASE WHEN tr.result_status = 'Abnormal' THEN 1 ELSE 0 END) 
        / COUNT(*) AS DECIMAL(5,2)
    ) AS abnormal_percentage
FROM medical_tests mt
JOIN test_order_details tod ON mt.test_id = tod.test_id
JOIN test_results tr ON tod.order_detail_id = tr.order_detail_id
GROUP BY mt.test_name
ORDER BY abnormal_percentage DESC;


------------------------------------------------------------
-- 8. Doctor-wise Revenue Contribution
------------------------------------------------------------
SELECT
    d.doctor_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(mt.cost) AS revenue_generated
FROM doctors d
JOIN test_orders o ON d.doctor_id = o.doctor_id
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN medical_tests mt ON tod.test_id = mt.test_id
GROUP BY d.doctor_name
ORDER BY revenue_generated DESC;


------------------------------------------------------------
-- 9. Repeat Patients
------------------------------------------------------------
SELECT
    p.patient_name,
    COUNT(o.order_id) AS total_orders
FROM patients p
JOIN test_orders o ON p.patient_id = o.patient_id
GROUP BY p.patient_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;


------------------------------------------------------------
-- 10. Orders with Missing Test Results
------------------------------------------------------------
SELECT
    o.order_id,
    p.patient_name,
    mt.test_name
FROM test_orders o
JOIN patients p ON o.patient_id = p.patient_id
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN medical_tests mt ON tod.test_id = mt.test_id
LEFT JOIN test_results tr ON tod.order_detail_id = tr.order_detail_id
WHERE tr.result_id IS NULL;


------------------------------------------------------------
-- 11. Average Test Turnaround Time (TAT)
------------------------------------------------------------
SELECT
    AVG(DATEDIFF(day, o.order_date, tr.result_date)) AS avg_turnaround_days
FROM test_orders o
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN test_results tr ON tod.order_detail_id = tr.order_detail_id;


------------------------------------------------------------
-- 12. Branch-wise Abnormal Result Percentage
------------------------------------------------------------
SELECT
    lb.branch_name,
    CAST(
        100.0 * SUM(CASE WHEN tr.result_status = 'Abnormal' THEN 1 ELSE 0 END)
        / COUNT(*) AS DECIMAL(5,2)
    ) AS abnormal_percentage
FROM lab_branches lb
JOIN test_orders o ON lb.branch_id = o.branch_id
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN test_results tr ON tod.order_detail_id = tr.order_detail_id
GROUP BY lb.branch_name;


------------------------------------------------------------
-- 13. Top Revenue Generating Test
------------------------------------------------------------
SELECT TOP 1
    mt.test_name,
    SUM(mt.cost) AS total_revenue
FROM medical_tests mt
JOIN test_order_details tod ON mt.test_id = tod.test_id
GROUP BY mt.test_name
ORDER BY total_revenue DESC;


------------------------------------------------------------
-- 14. New Patient Registrations by Month
------------------------------------------------------------
SELECT
    FORMAT(registration_date,'yyyy-MM') AS month,
    COUNT(*) AS new_patients
FROM patients
GROUP BY FORMAT(registration_date,'yyyy-MM')
ORDER BY month;


------------------------------------------------------------
-- 15. City-wise Test Demand
------------------------------------------------------------
SELECT
    p.city,
    mt.test_name,
    COUNT(*) AS test_count
FROM patients p
JOIN test_orders o ON p.patient_id = o.patient_id
JOIN test_order_details tod ON o.order_id = tod.order_id
JOIN medical_tests mt ON tod.test_id = mt.test_id
GROUP BY p.city, mt.test_name
ORDER BY test_count DESC;
