--data base TechForYou.ltd, occupation - IT services and HR outsourcing services

create database TechForYou
go

use TechForYou
go

create table MateEmployee (
Id int primary key, 
name nvarchar (20) not null, 
MNGid int,
foreign key (MNGid) references MateEmployee(Id),
roll nvarchar (20) not null,
salary money not null,
phone nvarchar (20) unique,
hiredate date default getdate (),
birthday date,
RecruitedById int 
)


create table clients (
Id int primary key identity ,
ClientName nvarchar (20), 
MngId nvarchar (20),
NmbrOfEmp  nvarchar (20)
)

create table OutsourceEmployees (
Id int primary key, 
name nvarchar (20) not null, 
MNGid int references MateEmployee  ,
roll nvarchar (20) not null,
client nvarchar (20) not null,
clientId int not null,
foreign key (clientId) references clients(Id),
salary money not null,
phone nvarchar (20) unique,
hiredate date default getdate (),
birthday date,
RecruitedById int 
)

create table candidates (
Id int primary key identity (1,1) ,
name nvarchar (20) not null, 
CandidateFor nvarchar (20) not null,
client nvarchar (20) not null,
clientId int not null ,
RecruitingBy nvarchar (20) not null,
SalaryExpectations money not null,
phone nvarchar (20) unique,
Availability nvarchar (20)
)

insert MateEmployee(Id, name, roll, salary, phone, hiredate, birthday) values (111, 'yossi cohen', 'CEO', '50,000','052-1111111','2010/01/01', '1975/03/01')
insert MateEmployee values (222, 'idan cohen', 111, 'VPL', '40,000', '052-2222222', '2010/01/10', '1980/08/10', null)
insert MateEmployee values (333, 'lilach hari', 111, 'BD.VPL', '35,000', '052-3333333', '2010/01/20', '1975/10/30', 111)
insert MateEmployee values(444, 'orel bok', 222, 'HR.MNG', '17,000', '052-444444', '2022/03/20', '1992/06/13', 333)

insert MateEmployee values (555, 'may od', 444, 'HR.ADMIN', '10,000', '052-5555555', '2022/08/01', '1997/04/29',444),
(666, 'shir shuk', 444, 'HR.ADMIN', '8,000', '052-6666666', '2025/03/01', '1999/07/01', 222)
insert MateEmployee values (777, 'moria cohen', 333, 'recruiter', '8,000', '052-777777', '2024/09/24', '1998/10/01', 333)
insert MateEmployee values (888, 'anael bent', 333, 'recruiter', '14,000', '052-8888888', '2024/10/01', '1991/06/19', 333),
(999, 'ashely noim', 333, 'business developer', '14,000', '052-9999999', '2023/01/01', '1991/06/11', 333),
(1010, 'aviv chen', 333, 'business developer', '14,000', '052-1010101', '2024/02/01', '1991/03/11', 333),
(1111, 'nave feld', 333, 'recruit maneger', '14,000', '052-11110111', '2021/10/31', '1991/03/09', 333),
(1212, 'nikol dem', 333,'recruiter', '10,000', '052-1212122', '2025/01/20', '1993/05/19', 333),
(1313, 'elinor fire', 111,'recruit maneger', '14,000', '052-1313311', '2024/12/20', '1991/06/21', 111),
(1414, 'nitzan sar', 1313,'recruiter', '10,000', '052-14141414', '2025/01/30', '1993/01/19', 333),
(1515, 'gabriela brig',1313,'recruiter', '10,000', '052-1515155', '2025/01/30', '1993/01/19', 1313)
insert MateEmployee values (1616, 'sali kal', 333,'recruiter', '10,000', '052-16161666', '2023/05/20', '1993/02/19', 333),
(1717, 'lichen bat', 1313,'recruiter', '10,000', '052-17171717', '2025/02/10', '1995/11/19', 1313)
insert MateEmployee values (1818, 'avichai shcur', 444, 'finance admin', '5,000', '052-1818181', '2022/08/20', '1995/04/05', 222),
(1919, 'valeri chaim',333,'recruiter', '10,000', '052-1919199', '2022/05/20', '1993/02/15', 333 ),
(2020, 'dikla las', 111, 'business developer', '16,000', '052-2020202', '2011/05/07', '1987/06/29', 333 )

insert into clients values ('bituach yashir', 333, 1 ), ('cal', 1010, 1), ('clal', 2020, 1), ('clalit',999, 2), ('delek', 1010, 1), ('discount', 999,2),
('eged', 1010,1), ('eldan', 1010, 1), ('fenix', 2020,1 ), ('hevrat hashmal', 1010,1), ('hot', 333,1), ('macabi',999,2), ('marcantil', 999,1), ('meitav dash', 333,1),
('migdal',2020,1), ('mivtach saimon', 2020, 2), ('paz', 999,1), ('shlomo sixt', 1010,1), ('ups', 999, 2), ('yes', 1010,1)

insert candidates values ('din rozen', 'data analyst', 'macabi',12, 888, '15,500', '052-8767890', 'month'),
('noy sade', 'sap admin', 'ups',19, 777, '10,600', '052-2445364', 'two weeks'),
('or levi', 'data analyst manager', 'macabi',12, 1212, '17,500', '053-5635234', 'month'),
('alex don', 'help desk', 'ups',19, 888,'10,500', '054-34565465', 'one week'),
('roy adar', 'Data Scientist', 'paz',17, 1414, '21,500', '053-5869466', 'two weeks'),
('chen ohev','software developer', 'fenix',9,1515, '20,000','052-77485958', 'month' )

insert candidates values ('lee alon', 'help desk', 'hevrat hashmal',10, 1919, '10,000', '050-89867599', 'month'),
('yaron tov', 'syber manager', 'fenix',9,1111 , '23,000', '052-45766577', 'month' ),
('gil levi', 'product manager','macabi',12, 888, '17,000', '052-8457849', 'teo weeks' ),
('aviv dayan','qa', 'delek', 5,1616, '11,000', '050-4537477', 'immediate' )

insert candidates values ('idan sade','help desk', 'hevrat hashmal',10,1919, '10,000', '050-3453636', 'immediate' ),
('nave ron', 'software developer', 'eldan',8,1414, '18,000', '052-3454578', 'month' ),
('nir gaon', 'syber', 'eldan',8,1717 , '18,000', '052-34536456', 'month'),
('naor leon','sap admin', 'meitav dash',14, 777, '12,000', '050-8689999','two weeks' ),
('ori ayalon','qa', 'migdal',15,888, '14,000', '052-86977646', 'immediate' ),
('avi joy','Data Scientist', 'clal',3,  1111,'23,500', '050-34545777', 'two weeks' ),
('gaya asher','data analyst', 'yes' ,20, 1515, '14,500', '050-8754444', 'month' )

insert candidates values ('ira david','qa', 'macabi',12,1818, '12,000', '050-97898665', 'month' )
insert candidates values ('gal miri', 'devops', 'macabi', 12,888,'24,000', '053-86875674', 'month'), ('shir sela','Data Scientist', 'macabi',12 , 1111,'22,000', '050-7555360', 'month' )

insert OutsourceEmployees values (11, 'avi ben', 1010, 'data analyst','eldan',8 , '15,000', '052-11011101', '2023/01/01', '1992/09/08', 1111),
(22, 'avi dani', 999, 'syber manager', 'macabi',12 , '20,000', '052-2212322', '2021/11/20', '1989/10/09', 1111 ),
(33, 'ofir ner', 999, 'data analyst', 'discount',6, '15,000', '052-33323333', '2024/01/01', '1990/07/16', 999),
(44, 'orel bin', 2020, 'sap admin', 'clal', 3, '16,500', '052-4434444', '2020/12/12', '1989/11/11', 2020),
(55, 'ester far', 1010, 'software developer', 'cal', 2, '18,000', '052-55554555', '2015/08/27', '1980/03/19', 2020 ),
(66, 'guy zar', 1010 , 'Data Scientist', 'delek',5 , '20,000', '050-66662666', '2023/12/31', '1981/01/03', 1919),
(77, 'bar lar', 999, 'help desk', 'ups' , 19,'9,000', '050-77778777', '2024/02/14', '1996/05/09', 1919 ),
(88, 'ziv lali', 1010, 'qa', 'shlomo sixt' ,18, '12,000', '050-88884888', '2019/08/25', '1993/12/23' , null)

insert OutsourceEmployees values (99, 'alon chai', 1010, 'qa', 'eged',7, '10,000', '050-9999099', '2025/03/23', '1994/06/14', 777),
(100, 'ela quli', 999, 'qa', 'paz',17, '11,000', '050-1000100', '2024/05/06', '1993/01/29', 1616 ),
(110, 'bar ozer', 999, 'Data Scientist', 'marcantil',13, '22,000', '050-1101101', '2023/04/04', '1994/10/23' ,1111),
(120, 'david cohen', 2020, 'software developer', 'fenix',9, '17,000', '052-12012000', '2025/07/17', '1990/02/21', 1515),
(130,  'yochanan menash', 2020, 'qa', 'mivtach saimon',16, '15,000', '052-13002000', '2025/02/17', '1996/07/01', 1414),
(140, 'matan tov',2020,'sap admin', 'migdal',15, '16,000', '052-14041400', '2025/04/28', '1989/11/11', 1212 ),
(150, 'yossi dani', 999 , 'Data Scientist', 'clalit', 4, '21,000', '050-15052000', '2025/05/04', '1995/09/23' ,1717 ),
(160, 'hila per', 1010, 'help desk', 'hevrat hashmal',10, '10,000', '050-16061000', '2023/03/04', '1992/08/09', 1919),
(170, 'yuval bali', 333, 'product manager','meitav dash',14, '15,000', '050-1701717', '2024/12/31', '1993/09/08', 888 )

insert OutsourceEmployees values (180, 'danit green', 333, 'help desk', 'bituach yashir', 1 ,'9,500', '050-1808018', '2025/06/13', '1999/05/10', 888 ),
(190, 'yarin sidi', 1010, 'data analyst', 'yes' ,20, '14,000', '050-19090110', '2024/02/19', '1995/03/09', 1616)
insert OutsourceEmployees values(200, 'mila kun', 333, 'erp manager' , 'hot',11, '25,000', '052-2002000', '2018/04/08', '1987/10/31', 2020)
insert OutsourceEmployees values(210, 'lee ale', 999, 'devops', 'macabi', 12,'22,000', '053-2121000', '2025/05/09', '1989/12/09', 888),
(220, 'mor levi', 999,'Data Scientist', 'clalit',4, '23,500', '050-2202200', '2017/02/04', '1988/08/23' ,2020 ),
(230, 'daniel mana',2020, 'help desk', 'mivtach saimon',16, '10,500', '052-2302300', '2025/07/07', '1996/07/01', 888 ),
(240, 'may sarusi', 999, 'data analyst', 'discount',6, '16,900', '052-2402400', '2017/03/03', '1989/06/16', 333 ),
(250,'guy harel', 999, 'sap admin', 'ups' ,19, '11,000', '050-2502500', '2024/10/30', '1993/01/01', 777)


select COUNT (*)
from OutsourceEmployees
group by clientId



--we want to know how many clients there is for every manager 

select  MngId, COUNT (MngId) as 'nmb_of_clients'
from clients
group by MngId



--we want to add information rather employee have keren hishtalmot or not.

alter table 
OutsourceEmployees add KerenHish nvarchar (10)

update OutsourceEmployees
set KerenHish = 'yes'
where salary >= '15,000'

update OutsourceEmployees
set KerenHish = 'no'
where salary < '15,000'


--we want to know how many outsource employees there is at every client

select count (*), client
from OutsourceEmployees
group by client

--we want to know how many outsource employees recruited  every recruiter

select count(o.id), o.recruitedbyid, m.name
from OutsourceEmployees o join MateEmployee m
on o.recruitedbyid=m.Id
where o.recruitedbyid is not null
group by o.recruitedbyid, m.name

--we want to know how many outsource employees works at gtech

select count (*)
from OutsourceEmployees

--we want to know 10 top salaries

select top 10 salary, name
from OutsourceEmployees
order by salary desc

--we want to know the avarage salary of gtech's outsouce employees

select AVG(salary) as avg_salary
from OutsourceEmployees

--we want to know the age of gtech's outsouce employees

select name, DATEDIFF(yy,birthday,GETDATE()) as age
from OutsourceEmployees

--we want to know the  avarage age of gtech's outsouce employees

select avg(DATEDIFF(yy,birthday,GETDATE())) as avg_age
from OutsourceEmployees

-- we want to know the status recruiting for the recruiters

select COUNT(c.id) as num_of_candidets, c.recruitingby, m.name
from candidates c join MateEmployee m
on c.recruitingby=m.Id
group by c.recruitingby, m.name