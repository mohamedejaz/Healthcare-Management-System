use mydb_final;

#1 Simple query:
#Using select to display all the names and specialization of the doctor:

SELECT name, specialization FROM Doctors;                                              

#2 Aggregate query:
#Total amount due for payment under each payment method:

SELECT payment_method, SUM(amount_due) as Total_Amount_Due FROM payment_details GROUP BY payment_method;
 

#3 Joins:
#Show the average and total price of pharmacy orders for each patient:

SELECT pd.name AS patient_name, AVG(po.total_price) AS avg_order_price, SUM(po.total_price) AS total_order_price
FROM Patient_Details pd
JOIN Med_Buys mb ON pd.Patient_id = mb.PatientID
JOIN Pharmacy_Orders po ON mb.OrderID = po.Order_id
GROUP BY pd.name
ORDER BY total_order_price DESC;
 
#4. Nested query:
#Doctors that have lower average ratings than the overall average:

SELECT name as Doctors_with_low_avg_ratings
FROM Doctors
WHERE Doctor_id IN (
    SELECT doctorID
    FROM Patients_Feedback
    GROUP BY doctorID
    HAVING AVG(ratings) < (SELECT AVG(ratings) FROM Patients_Feedback));
 

#5 Correlated query:
#Find doctor details with appointments between specific dates:

SELECT * FROM Doctors d 
WHERE EXISTS (SELECT 1 FROM Appointments a 
              WHERE a.doctorID = d.Doctor_id AND a.date >= '2023-03-20' AND a.date<= '2023-04-20');
 


#6 Query using ALL/ANY:
#Find doctors who have the highest total number of appointments with the patients:

SELECT name as Doctor_with_highest_appointments
FROM Doctors d
WHERE (
    SELECT COUNT(Appointment_id)
    FROM Appointments a
    WHERE a.doctorID = d.Doctor_id
) >= ALL (
    SELECT COUNT(Appointment_id)
    FROM Appointments a2
    GROUP BY a2.doctorID
    HAVING COUNT(Appointment_id) IS NOT NULL
    AND a2.doctorID <> d.Doctor_id
);
 

#7 Query using EXISTS:
#Query Doctors who have done more than 3 surgeries:

SELECT name as Doctors_done_more_than_3_surgeries
FROM Doctors d
WHERE EXISTS (
    SELECT 1
    FROM Surgery s
    WHERE s.doctorID = d.Doctor_id
    GROUP BY s.doctorID
    HAVING COUNT(s.surgeryID) > 3
);
 




#8 Set operations:
#Retrieve the names of patients who have either undergone lab tests or surgeries:

SELECT name FROM Patient_Details
WHERE EXISTS (
    SELECT 1 FROM Lab_Tests WHERE Lab_Tests.TestID = Patient_Details.Patient_id
)
UNION
SELECT name FROM Patient_Details
WHERE EXISTS (
    SELECT 1 FROM Surgery WHERE Surgery.patientID = Patient_Details.Patient_id
);
 

#9 Subqueries in select:
#Retrieving Patients and their total appointments count overall

SELECT name as Patient_name, (SELECT COUNT(*) FROM Appointments a WHERE a.patientID = p.Patient_id) AS appointment_count
FROM Patient_Details p ORDER BY appointment_count DESC ;
 

#10 Subqueries:
#Retrieve patient name and age for those who have age greater than average age among all patients:

SELECT name as Patient_name, age
FROM patient_details
WHERE age > (SELECT AVG(age) FROM Patient_Details)
ORDER BY age DESC
