--SQL PROJECT 
--Script 1

--Creating game Database

Create database [CatchTheFish] 

--creating Users Table
create TABLE users
(
UserID int not null unique,
UserName NVARCHAR (40) primary key,
Password NVARCHAR (20) NOT NULL,
FirstName NVARCHAR(15) NOT NULL,
LastName NVARCHAR (20) NOT NULL,
Address NVARCHAR (30),
CountryName VARCHAR (30) foreign key references dbo.country(countryName), 
CHECK (countryName in ('United States', 'Australia', 'United Kingdom', 'Canada', 'China', 'Japan', 
'France', 'Germany', 'Brazil', 'South Africa')), 
email NVARCHAR (50) unique NOT NULL
check (email LIKE ('%@%')),
Birthdate date NOT NULL,
check (datediff(year, birthdate, getdate()) > = 13) ,
Gender nvarchar(6),  
check (Gender in ('Male', 'Female'))
)

-- Country Table

Create Table country
(CountryID int NOT NULL, 
CountryName Varchar (30) NOT NULL primary key)
Insert into dbo.country VALUES
(1, 'United States'),
(2, 'Canada'),
(3, 'United Kingdom'),
(4, 'Australia'),
(5, 'China'),
(6, 'Japan'),
(7, 'France'),
(8, 'Germany'),
(9, 'South Africa'),
(10, 'Brazil')


--fisher name table

create table fisher_name 
(ID int identity , 
fishername nvarchar(30) primary key
)

insert into fisher_name
values ('avi') , ('moshe'), ('sher')

--transaction table 

create table [transaction table] 
(SN int identity not null,
username nvarchar(40) FOREIGN KEY REFERENCES users(username) not null, 
quantity int not null,
[type] nvarchar(30) not null,
[date] datetime not null)

--View for Rand values

create view vv_RAND
as
select rand() as [value]



--Creating scalar funtion that returns random value

create function fn_Rand(@Lower int, @Upper int)
returns int
as
Begin
DECLARE @Random INT;
if @Upper > @Lower
	SELECT @Random = (1 + @Upper - @Lower) * (SELECT Value FROM vv_RAND) + @Lower
Else
	SELECT @Random = (1 + @Lower - @Upper) * (SELECT Value FROM vv_RAND) + @Upper
return @Random
end


--score function 
create function fn_score (@username nvarchar(300))
returns table 
as
return(SELECT username, 
	Sum (quantity) as points,
	SUM(CASE WHEN type='loss' THEN 1 ELSE 0 END)+SUM(CASE WHEN type='loss' THEN 1 ELSE 0 END)AS TotalGames,
  SUM(CASE WHEN type='win' THEN 1 ELSE 0 END) AS Wins,
  SUM(CASE WHEN type='loss' THEN 1 ELSE 0 END) AS Losses,
  SUM(CASE WHEN type='win' THEN 1 ELSE 0 END)*100/COUNT(*) AS WinPercentage
FROM [transaction table]
GROUP BY username)


--SP starting the game
create procedure sp_startingthegame
as 
select 'register now'
select 'already have an account? log-in'



--registeration Procedure 

create procedure sp_registeration 
@username nvarchar (20), 
@firstname nvarchar (20),
@lastname nvarchar (20),
@password nvarchar (15),
@email nvarchar(50),
@address nvarchar(30),
@countryName nvarchar(20),
@Birthdate date,
@Gender nvarchar(6)
AS

DECLARE @count int
set @count = 0
declare @R int
set @R =dbo.fn_rand(11,99)
BEGIN
IF EXISTS
		(select username
		from USERS
		where username = @username)
BEGIN
while @R>=1
begin
IF not exists (select username from users where UserName =  @username + cast(@R AS VARCHAR)) 
BEGIN
PRINT ('Username already exists, Try ' + @username + cast(@R AS VARCHAR))
set @count = @count +1
end
else
set @R = @R + 1
END
END




IF
	(@password not like '%[0-9]%') or 
	(len(@password)<7) or 
	@password NOT LIKE '%[A-Z]%' COLLATE Latin1_General_BIN  or
	@password NOT LIKE '%[a-z]%' COLLATE Latin1_General_BIN 
	or @password = 'password'
	or @password = @username
PRINT @Password + ' is not valid, Try again'
set @count= @count+1

if (@email not like '%@%')
print 'please insert a legit email for example : example@gmail.com'
set @count= @count+1


IF EXISTS
		(select email from users
		where email = @email)
begin
PRINT 'Email already exists'
set @count= @count+1

end


IF datediff(year, @Birthdate, getdate()) < 13
begin
Print 'Ops! You are not allowed to register'
set @count= @count+1

end


If @countryName not in ('United States', 'Australia', 'United Kingdom', 'Canada', 'China', 'Japan', 
'France', 'Germany', 'Brazil', 'South Africa')
begin
print ' choose country from the following: United States, Australia, United Kingdom, Canada, China, Japan, 
France, Germany, Brazil, South Africa'
set @count= @count+1

end


IF @count =0
begin
Insert into USERS(userID ,username, FirstName, LastName, password, email, Address, CountryName, birthdate, Gender)
VALUES ((select COUNT(userId)+1  FROM USERS), @username, @firstname, @lastname, @password, @email, @address, @countryName, @Birthdate, @Gender)
Print 'Your username is  ' + @username
PRINT 'Your password is' + @password 
Print 'Firstname is ' + @firstname
Print 'Lastname is ' + @lastname
Print 'Country is: ' + @countryName
print 'Birthdate: ' + cast(@birthdate AS VARCHAR)
exec SP_registeration_bonus
END
END


-- SP transaction for bonus when registration

create procedure SP_registeration_bonus
as
declare 
@TID int,
@username nvarchar(200),
@quantity int,
@type nvarchar(30),
@date datetime, 
@bonus int='1000'

set @username = (select username from users  where userID=(select max(userid) from users))

insert into [transaction table] (username,quantiTY,type,date)
values (@username , @bonus , 'bonus' , getdate())



-- sp_login
CREATE procedure SP_login (@username nvarchar(300), @psw nvarchar(300))
as 
 if exists (select * from users where username = @username)
	begin
		if @psw = (select password from users where username = @username)
			begin
			
			select 'login access'
			select 'start game'
			exec sp_score @username
		
			end 
		else
			print 'incorrect password TRY AGAIN'
	end
else
	print 'login failed INCORRECT USERNAME'



--choosing fisher name

create procedure SP_choosing_fishername 
as
		SELECT * FROM fisher_name



--sp score
create procedure sp_score (@username nvarchar(300))
as
select*
from dbo.fn_score(@username)
where username = @username


-- SP_GAME 
create PROCEDURE GAME (@USERNAME NVARCHAR(40) , @FISHERNAME NVARCHAR(30))
AS

if not exists (select * from fisher_name where fishername= @fishername)
		begin
		select @fishername +' is not on the fisher name list'
		select 'PLEASE CHECK OUR FISHER NAME TABLE'
		exec SP_choosing_fishername 

		end
else
begin
		print @fishername +' '+ 'is now your fishername'

set NOCOUNT ON
declare @points int 
set @points = (select sum(quantity) from [transaction table] where USERNAME= @username)
if @points<=100 
print 'you dont have enough points to play the game'
else 
begin

declare @F table 
(ID int identity, steps int)

declare 
@start int, 
@max int, 
@y int,
@x int,
@R int, 
@s int,
@W int,
@Q int,
@P int,
@E int, 
@T int,
@U int 

set @start=0
set @max=15

set @Y=(select dbo.fn_rand(@start,@max))
set @X=(select dbo.fn_rand(@start,@max))
set @R=(select dbo.fn_rand(@start,@max))
set @S=(select dbo.fn_rand(@start,@max))
set @w=(select dbo.fn_rand(@start,@max))
set @Q=(select dbo.fn_rand(@start,@max))
set @P=(select dbo.fn_rand(@start,@max))
set @E=(select dbo.fn_rand(@start,@max))
set @T=(select dbo.fn_rand(@start,@max))
set @U=(select dbo.fn_rand(@start,@max))

insert into @f select @y
insert into @f select @Y + @X
insert into @f select @Y + @X + @R
insert into @f select @Y + @X + @R+ @S
insert into @f select @Y + @X + @R+ @S + @W
insert into @f select @Y + @X + @R+ @S + @W + @Q
insert into @f select @Y + @X + @R+ @S + @W + @Q + @P
insert into @f select @Y + @X + @R+ @S + @W + @Q + @P + @E
insert into @f select @Y + @X + @R+ @S + @W + @Q + @P + @E + @T
insert into @f select @Y + @X + @R+ @S + @W + @Q + @P + @E + @T +@U


declare @F1 table 
(ID int identity, steps int)

declare 
@start1 int, 
@max1 int, 
@y1 int,
@x1 int,
@R1 int, 
@s1 int,
@W1 int,
@Q1 int,
@P1 int,
@E1 int, 
@T1 int,
@U1 int 

set @start1=0
set @max1=15

set @Y1=(select dbo.fn_rand(@start1,@max1))
set @X1=(select dbo.fn_rand(@start1,@max1))
set @R1=(select dbo.fn_rand(@start1,@max1))
set @S1=(select dbo.fn_rand(@start1,@max1))
set @w1=(select dbo.fn_rand(@start1,@max1))
set @Q1=(select dbo.fn_rand(@start1,@max1))
set @P1=(select dbo.fn_rand(@start1,@max1))
set @E1=(select dbo.fn_rand(@start1,@max1))
set @T1=(select dbo.fn_rand(@start1,@max1))
set @U1=(select dbo.fn_rand(@start1,@max1))

insert into @f1 select @y1
insert into @f1 select @Y1 + @X1
insert into @f1 select @Y1 + @X1 + @R1
insert into @f1 select @Y1 + @X1 + @R1+ @S1
insert into @f1 select @Y1 + @X1 + @R1+ @S1 + @W1
insert into @f1 select @Y1 + @X1 + @R1+ @S1 + @W1 + @Q1
insert into @f1 select @Y1 + @X1 + @R1+ @S1 + @W1 + @Q1 + @P1
insert into @f1 select @Y1 + @X1 + @R1+ @S1 + @W1 + @Q1 + @P1 + @E1
insert into @f1 select @Y1 + @X1 + @R1+ @S1 + @W1 + @Q1 + @P1 + @E1 + @T1
insert into @f1 select @Y1 + @X1 + @R1+ @S1 + @W1 + @Q1 + @P1 + @E1 + @T1 +@U1

declare @F2 table 
(ID int identity, steps int)

declare 
@start2 int, 
@max2 int, 
@y2 int,
@x2 int,
@R2 int, 
@s2 int,
@W2 int,
@Q2 int,
@P2 int,
@E2 int, 
@T2 int,
@U2 int 

set @start2=0
set @max2=15

set @Y2=(select dbo.fn_rand(@start2,@max2))
set @X2=(select dbo.fn_rand(@start2,@max2))
set @R2=(select dbo.fn_rand(@start2,@max2))
set @S2=(select dbo.fn_rand(@start2,@max2))
set @w2=(select dbo.fn_rand(@start2,@max2))
set @Q2=(select dbo.fn_rand(@start2,@max2))
set @P2=(select dbo.fn_rand(@start2,@max2))
set @E2=(select dbo.fn_rand(@start2,@max2))
set @T2=(select dbo.fn_rand(@start2,@max2))
set @U2=(select dbo.fn_rand(@start2,@max2))

insert into @f2 select @y2
insert into @f2 select @Y2 + @X2
insert into @f2 select @Y2 + @X2 + @R2
insert into @f2 select @Y2 + @X2 + @R2+ @S2
insert into @f2 select @Y2 + @X2 + @R2+ @S2 + @W2
insert into @f2 select @Y2 + @X2 + @R2+ @S2 + @W2 + @Q2
insert into @f2 select @Y2 + @X2 + @R2+ @S2 + @W2 + @Q2 + @P2
insert into @f2 select @Y2 + @X2 + @R2+ @S2 + @W2 + @Q2 + @P2 + @E2
insert into @f2 select @Y2 + @X2 + @R2+ @S2 + @W2 + @Q2 + @P2 + @E2 + @T2
insert into @f2 select @Y2 + @X2 + @R2+ @S2 + @W2 + @Q2 + @P2 + @E2 + @T2 +@U2

declare @counter int , @ID int
set @counter = 1
set @ID =1
WHILE @COUNTER <=10
BEGIN
if @counter<10
begin
	print ' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
	declare @fish1 nvarchar (20)
	declare @Fuc1 int 
	

	set @fish1 = '><(((o>'
	set @fuc1 = (select steps from @f where id=@id)
	print replicate (' ' , @fuc1)+ @fish1


	declare @fish2 nvarchar (20)
	declare @fuc2 int 


	set @fish2 = '><(((o>'
	set @fuc2 = (select steps from @f1 where id=@id)
	print replicate (' ' , @fuc2)+ @fish2
	

	declare @fish3 nvarchar (20)
	declare @fuc3 int 


	set @fish3 = '><(((o>'
	set @fuc3 = (select steps from @f2 where id=@id)
	print replicate (' ' , @fuc3)+ @fish3

	
	
	set @ID = @ID+1
	SET @COUNTER = @COUNTER + 1

 END
	else
		if @counter=10
		begin 
		print ' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
		declare @fish4 nvarchar(20) , @random int ,@WIN int='1000', @loss int='-100' , @cage nvarchar(20)
		set @random =(select dbo.fn_rand(1,3))
		set @fish4 = '|><(((o>|'
		set @cage  = '---------'
		
		if @random = 1 
				BEGIN 
				print replicate (' ', @fuc1)+ @cage
				print replicate (' ', @fuc1)+ @fish4
				print replicate (' ', @fuc1)+ @cage
			IF @FISHERNAME = 'AVI'
				insert into [transaction table]
				values (@username , @WIN , 'win' , getdate())
				END
		else 
				begin
				set @fish1 = '><(((o>'
				set @fuc1 = (select steps from @f where id=@id)
				print replicate (' ' , @fuc1)+ @fish1
			if @FISHERNAME = 'AVI'
				insert into [transaction table]
				values (@username , @loss , 'loss' , getdate())
				END
				

		if @random = 2 
				BEGIN
				print replicate (' ', @fuc2)+ @cage
				print replicate (' ' , @fuc2)+ @fish4
				print replicate (' ', @fuc2)+ @cage
			IF @FISHERNAME = 'MOSHE'
				insert into [transaction table]
				values (@username , @WIN , 'win' , getdate())
				END
		else	
				begin
				set @fish2 = '><(((o>'
				set @fuc2 = (select steps from @f1 where id=@id)
				print replicate (' ' , @fuc2)+ @fish2
			IF @FISHERNAME = 'MOSHE'
				insert into [transaction table]
				values (@username , @loss , 'loss' , getdate())
				end

		if @random = 3
				begin
				print replicate (' ', @fuc3)+ @cage
				print replicate (' ' , @fuc3)+ @fish4
				print replicate (' ', @fuc3)+ @cage
			IF @FISHERNAME = 'SHER'
				insert into [transaction table]
				values (@username , @WIN , 'win' , getdate())
				end
		else
				begin
				set @fish3 = '><(((o>'
				set @fuc3 = (select steps from @f2 where id=@id)
				print replicate (' ' , @fuc3)+ @fish3
			IF @FISHERNAME = 'SHER'
				insert into [transaction table]
				values (@username , @loss , 'loss' , getdate())
				END			 
	
	break
	END
END
print 'GAME OVER'
IF @RANDOM =1 PRINT 'AVI HAVE WON THE GAME'
IF @RANDOM =2 PRINT 'MOSHE HAVE WON THE GAME'
IF @RANDOM =3 PRINT 'SHER HAVE WON THE GAME'
end
end
 

		




