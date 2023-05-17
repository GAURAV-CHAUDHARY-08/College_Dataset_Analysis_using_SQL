#Find the number of students who are studying in BSc CS and also their gender is female.
select count(*) as no_of_student from college_dataset
where Gender = "F" and Course = 'B.Sc(CS)';


#Show the list of students who are studying in CBZ and also their course fees is 16000.
select * from college_dataset
where Course_Fees = 16000 and Course = 'CBZ';


#Show the list of students whose first name like Ajay, Anuj, Dhruv, Gaurav, Jatin and Nitin of B.Sc(CS) group.
select * from college_dataset
where First_Name in ("Ajay", "Anuj", "Dhruv", "Gaurav", "Jatin", "Nitin") and Course = 'B.Sc(CS)';


#Show the list of students their last name like Chaudhary, Sharma, Mishra and Pal.
select * from college_dataset
where Last_Name in ("Chaudhary", "Sharma", "Mishra", "Pal");


/*The college people have thought of conducting elections in the college.
So, the criteria for selecting the representative has been kept in such a way 
that the one whose attendance is above 80 percents and marks more than 80 percents in the last exam.*/
select First_Name, Last_Name, Course from
(select *, round((Attandence/`Total_No._Of_Class`)*100,0) as Percentage_of_attandence, 
round((Marks_in_Last_Examination/1200)*100,0) as Marks_percentage
from college_dataset ) a
where Percentage_of_attandence > 80 and Marks_percentage > 80 ;


#Show the list of students that have more than 80% of their attendance.
select First_Name, Last_Name, Course from
(select *, round((Attandence/`Total_No._Of_Class`)*100,0) as Percentage_of_attandence
from college_dataset ) a
where Percentage_of_attandence > 80 ;


#Find the student that have earned 5th rank for their course group and semester according to their marks.
-- For 'B.Sc(CS)' group
select First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, Position from
(select *, dense_rank() over(partition by Semester order by Marks_in_Last_Examination desc ) as Position from 
(select * from college_dataset 
where Course = 'B.Sc(CS)')a)b
where Position = 5;

-- For CBZ group
select First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, Position from
(select *, dense_rank() over(partition by Semester order by Marks_in_Last_Examination desc ) as Position from 
(select * from college_dataset 
where Course = 'CBZ')a)b
where Position = 5;



/*It is a matter of time before some children were playing cricket before the paper in the college, 
one of them hit the shot for six and it hit the glass of the principal's car, 
then the principal fined all those children equally, so now show that if the price of that glass is 6 thousand rupees, 
then how much money will be increased among all, after the relaxation of their fees, 
the roll numbers of those children are like this 13,19,57,43,95,63,23 and these student are of CBZ group*/
select d.*, round(((6000/7)+Fees_after_relexation),0) as Fees_after_broken_car_glass from
(select c.`Roll_No.`,c.First_Name,c.Last_Name,c.Gender,c.Course,c.Semester,c.Course_Fees,c.`Relaxation in Fees`,
c.Course_Fees-c.`Relaxation in Fees` as Fees_after_relexation from
(select a.*, b.`Relaxation in Fees` from college_dataset as a
join relaxation as b
on a.`Roll_No.` = b.`Roll No.`
and a.Course = b.Course )c
where c.`Roll_No.` in (13,19,57,43,95,63,23) and c.Course = "CBZ")d;



#Show the list of top 5 rank holders for each group and semester according to their marks.
-- For 'CBZ' group
select First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, Position from
(select *, dense_rank() over(partition by Semester order by Marks_in_Last_Examination desc ) as Position from 
(select * from college_dataset 
where Course = 'CBZ')a)b
where Position <= 5;

-- For 'B.Sc(CS)' group
select First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, Position from
(select *, dense_rank() over(partition by Semester order by Marks_in_Last_Examination desc ) as Position from 
(select * from college_dataset 
where Course = 'B.Sc(CS)')a)b
where Position <= 5;



#Show the list of students that earn more than 80% in their practical but earn less than 65% in their theory examination.
select * from
(select `Roll_No.`, First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, 
round(((Marks_in_Last_Examination/1200)*100),0) as Percentage_in_last_examination,
Marks_of_Practical_Out_Of_120, round(((Marks_of_Practical_Out_Of_120/120)*100),0) as Percentage_in_practical from
(select a.*, b.Marks_of_Practical_Out_Of_120 from college_dataset as a
join practical_marks as b
on a.`Roll_No.` = b.`Roll_No.` and a.Course = b.Course)c)d
where Percentage_in_last_examination < 65 and Percentage_in_practical > 80 ;



#Show all the details of the students after relaxation in their fees.
select c.`Roll_No.`,c.First_Name,c.Last_Name,c.Gender,c.Course,c.Semester,c.Course_Fees,c.`Relaxation in Fees`,
c.Course_Fees-c.`Relaxation in Fees` as Fees_after_relexation from
(select a.*, b.`Relaxation in Fees` from college_dataset as a
join relaxation as b
on a.`Roll_No.` = b.`Roll No.`
and a.Course = b.Course )c;



#Show the list of students that were failed in the exam according to their total marks. (let's say less than 60%)
select * from
(select *, round(((Total_Marks/1320)*100),0) as Total_Percentage from
(select `Roll_No.`, First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, 
Marks_of_Practical_Out_Of_120, Marks_in_Last_Examination + Marks_of_Practical_Out_Of_120 as Total_Marks from
(select a.*, b.Marks_of_Practical_Out_Of_120 from college_dataset as a
join practical_marks as b
on a.`Roll_No.` = b.`Roll_No.` and a.Course = b.Course) c ) d ) e
where Total_Percentage < 60 ;



/*The college committee decided to give 5000 relaxation in the fees of students who have attendance more than 95%.
Now show the list of students with all other details after relaxation their fees and additional relaxation of their fees 
according to their attendance.*/
select *,
case 
	when Percentage_of_attandence >= 95 then Fees_after_relaxation - 5000
    else Fees_after_relaxation
end as Final_Fees
from
(select `Roll_No.`, First_Name, Last_Name, Gender, Course, Semester, 
Course_Fees - `Relaxation in Fees` as Fees_after_relaxation,
round(((Attandence/`Total_No._Of_Class`)*100),0) as Percentage_of_attandence from
(select a.*, b.`Relaxation in Fees` from college_dataset as a
join relaxation as b
on a.`Roll_No.` = b.`Roll No.` and a.Course = b.Course) c) d;



#Show the list of students who have scored 100 in their practical exam and grouped by their course group.
select `Roll_No.`, First_Name, Last_Name, Gender, Course, Semester, Marks_in_Last_Examination, Marks_of_Practical_Out_Of_120 from
(select a.*, b.Marks_of_Practical_Out_Of_120 from college_dataset as a
join practical_marks as b
on a.`Roll_No.` = b.`Roll_No.` and a.Course = b.Course) c
where Marks_of_Practical_Out_Of_120 = 100 ;



/*Every year in college, those studying in 5th sem have to give farewell party to the students of 6th sem, 
in which the fee for this time is ₹ 500.
Whichever child is in the fifth semester, by increasing his fee by ₹ 500 and applying all exemptions, 
tell how much fee he has to deposit.*/
select *,
case 
	when Percentage_of_attandence >= 95 then Fees_after_relaxation - 5000
    when Semester = 'Fifth' then Fees_after_relaxation + 500
    else Fees_after_relaxation
end as Final_Fees
from
(select `Roll_No.`, First_Name, Last_Name, Gender, Course, Semester, 
Course_Fees - `Relaxation in Fees` as Fees_after_relaxation,
round(((Attandence/`Total_No._Of_Class`)*100),0) as Percentage_of_attandence from
(select a.*, b.`Relaxation in Fees` 
from college_dataset as a
join relaxation as b
on a.`Roll_No.` = b.`Roll No.` and a.Course = b.Course) c) d;