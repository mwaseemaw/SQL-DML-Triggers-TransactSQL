use company

drop table empAudit
create table empAudit
(
	empAudit_id int identity(500,2) primary key,
	emp_id int,
	actionTaken varchar(300),
	eventDate datetime NOT NULL,
	changeBy sysname NOT NULL
)

CREATE TRIGGER trigger_empAudit
ON employee
AFTER  INSERT, DELETE,  UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmpId int
	select @EmpId = emp_id from employee
	IF EXISTS (SELECT * FROM inserted where inserted.emp_id = @EmpId) and  EXISTS (SELECT * FROM deleted where deleted.emp_id = @EmpId)
	BEGIN
		insert into empAudit values(@Empid,'UPDATE',GETDATE(),USER)
		PRINT 'UPDATE DONE';
	END
	ELSE IF EXISTS (SELECT * FROM inserted where inserted.emp_id = @EmpId) 
	BEGIN
		insert into empAudit values(@Empid,'INSERT',GETDATE(),USER)
		PRINT 'INSERT DONE';
	END
	ELSE IF EXISTS (SELECT * FROM deleted) 
	BEGIN
		select @Empid = emp_id FROM deleted;
		insert into empAudit values(@Empid,'DELETE',GETDATE(),USER)
		PRINT 'DELETE DONE';
	END
END
drop trigger trigger_empAudit

--FOR TESTING
select * from employee
select * from empAudit
delete from employee where dept_id=103
update employee set emp_name = 'mohd abrar' where emp_id=13
insert into employee values ('Abrar', 'abrar@email.com',102)