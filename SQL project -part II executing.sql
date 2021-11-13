--sql project 
--script 2


SELECT* from users

--starting the game
exec sp_startingthegame

--registration procedure


EXEC sp_registeration
@username  = 'John',
@firstname = 'John',
@lastname='Haddad',
@password= 'JHaddad23',
@email= 'jhon10@gmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2000-05-13',
@Gender= 'male'



--test 1 - username already exists

EXEC sp_registeration
@username  = 'John',
@firstname = 'John',
@lastname='Haddad',
@password= 'JHaddad23',
@email= 'jhon98@gmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2000-05-13',
@Gender= 'male'


--test 2 -PASSWORD TEST - CANT REGISTER WITH WEAK PASSWORD(WITHOUT NUMBERS AND CAPITAL LETTERS)

EXEC sp_registeration
@username  = 'John1111',
@firstname = 'John',
@lastname='Haddad',
@password= 'abdddw',
@email= 'jhon1111@gmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2000-05-13',
@Gender= 'male'


--test 3 -PASSWORD TEST - CANT REGISTER WITH PASSWORD AS 'PASSWORD'

EXEC sp_registeration
@username  = 'John123',
@firstname = 'John',
@lastname='Haddad23',
@password= 'PASSWORD',
@email= 'jhon123@gmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2000-05-13',
@Gender= 'male'


--test 4 -EMAIL TEST - WITHOUT VALID EMAIL CANNOT REGISTER

EXEC sp_registeration
@username  = 'John12345',
@firstname = 'John',
@lastname='jHaddad23',
@password= 'JHaddad23',
@email= 'jhongmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2000-05-13',
@Gender= 'male'

--test 5 - EMAIL ALREADY EXISTS - 

EXEC sp_registeration
@username  = 'John123456',
@firstname = 'John',
@lastname='Haddad23',
@password= 'jHaddad23',
@email= 'jhon@gmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2000-05-13',
@Gender= 'male'



--test 6 - young users -FAIL 

EXEC sp_registeration
@username  = 'John123456',
@firstname = 'John',
@lastname='Haddad23',
@password= 'jHaddad23',
@email= 'jhon666@gmail.com',
@Address = 'Sarona 12',
@countryName='germany ', 
@birthdate = '2012-05-13',
@Gender= 'male'



--login procedure

--test 1 successful login
exec SP_login john , JHaddad23

--test 2 username does not exist
exec SP_login rand ,raaaa

--test 3 incorrect password
exec SP_login john , Abddd32




--game
EXEC GAME JOhn , AVI
--test 1 - incorrect fisher name
exec game john , ben



--sp_score

exec sp_score john






