-- SQL Schema for a School Management System
-- This script creates a set of tables for managing schools, staff, students, and classes, along with relationships such as addresses, salaries, and parents.

-- Table: ADDRESS
-- Stores addresses for schools, staff, and parents.
CREATE TABLE IF NOT EXISTS ADDRESS
(
    ADDRESS_ID       VARCHAR(20) PRIMARY KEY, -- Unique identifier for each address
    STREET           VARCHAR(250),            -- Street information
    CITY             VARCHAR(100),            -- City information
    STATE            VARCHAR(100),            -- State information
    COUNTRY          VARCHAR(100)             -- Country information
);

-- Table: SCHOOL
-- Stores information about different schools.
CREATE TABLE IF NOT EXISTS SCHOOL
(
    SCHOOL_ID         VARCHAR(20) PRIMARY KEY, -- Unique identifier for each school
    SCHOOL_NAME       VARCHAR(100) NOT NULL,   -- Name of the school
    EDUCATION_BOARD   VARCHAR(80),             -- Education board affiliated with the school
    ADDRESS_ID        VARCHAR(20),             -- Reference to the address of the school
    CONSTRAINT FK_SCHOOL_ADDR FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID) -- Foreign key linking to the ADDRESS table
);

-- Table: STAFF
-- Stores information about staff members (teachers, administrative staff, etc.).
CREATE TABLE IF NOT EXISTS STAFF
(
    STAFF_ID         VARCHAR(20),             -- Unique identifier for each staff member
    STAFF_TYPE       VARCHAR(30),             -- Type of staff (e.g., Teacher, Admin)
    SCHOOL_ID        VARCHAR(20),             -- Reference to the school where the staff works
    FIRST_NAME       VARCHAR(100) NOT NULL,   -- Staff first name
    LAST_NAME        VARCHAR(100) NOT NULL,   -- Staff last name
    AGE              INT,                     -- Age of the staff member
    DOB              DATE,                    -- Date of birth
    GENDER           VARCHAR(10) CHECK (GENDER IN ('M', 'F', 'Male', 'Female')), -- Gender with a constraint
    JOIN_DATE        DATE,                    -- Date when the staff member joined
    ADDRESS_ID       VARCHAR(20),             -- Reference to staff's address
    CONSTRAINT PK_STAFF PRIMARY KEY(STAFF_ID), -- Primary key on STAFF_ID
    CONSTRAINT FK_STAFF_SCHL FOREIGN KEY(SCHOOL_ID) REFERENCES SCHOOL(SCHOOL_ID), -- Foreign key linking to the SCHOOL table
    CONSTRAINT FK_STAFF_ADDR FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID) -- Foreign key linking to the ADDRESS table
);

-- Table: STAFF_SALARY
-- Stores salary information for each staff member.
CREATE TABLE IF NOT EXISTS STAFF_SALARY
(
    STAFF_ID         VARCHAR(20) PRIMARY KEY, -- Unique identifier for each staff member
    SALARY           FLOAT,                   -- Salary amount
    CURRENCY         VARCHAR(5)                -- Currency type (e.g., USD, INR)
);

-- Table: SUBJECTS
-- Stores information about subjects.
CREATE TABLE IF NOT EXISTS SUBJECTS
(
    SUBJECT_ID       VARCHAR(20) PRIMARY KEY, -- Unique identifier for each subject
    SUBJECT_NAME     VARCHAR(50) NOT NULL     -- Name of the subject
);

-- Table: CLASSES
-- Stores information about classes, subjects, and assigned teachers.
CREATE TABLE IF NOT EXISTS CLASSES
(
    CLASS_ID         VARCHAR(20),             -- Unique identifier for each class
    CLASS_NAME       VARCHAR(50) NOT NULL,    -- Name of the class (e.g., Grade 1, Grade 2)
    SUBJECT_ID       VARCHAR(20),             -- Reference to the subject being taught in the class
    TEACHER_ID       VARCHAR(20),             -- Reference to the teacher assigned to the class
    CONSTRAINT FK_STAFF_SUBJ FOREIGN KEY(SUBJECT_ID) REFERENCES SUBJECTS(SUBJECT_ID), -- Foreign key linking to the SUBJECTS table
    CONSTRAINT FK_STAFF_STFF FOREIGN KEY(TEACHER_ID) REFERENCES STAFF(STAFF_ID), -- Foreign key linking to the STAFF table
    CONSTRAINT PK_CLASSES PRIMARY KEY (CLASS_ID, CLASS_NAME, SUBJECT_ID) -- Composite primary key for each class
);

-- Table: STUDENTS
-- Stores information about students.
CREATE TABLE IF NOT EXISTS STUDENTS
(
    ID               VARCHAR(20) PRIMARY KEY, -- Unique identifier for each student
    FIRST_NAME       VARCHAR(100) NOT NULL,   -- Student's first name
    LAST_NAME        VARCHAR(100) NOT NULL,   -- Student's last name
    GENDER           VARCHAR(10) CHECK (GENDER IN ('M', 'F', 'Male', 'Female')), -- Gender constraint
    AGE              INT,                     -- Age of the student
    DOB              DATE,                    -- Date of birth
    IS_ACTIVE        VARCHAR(1),              -- Indicates if the student is currently active
    CONSTRAINT CH_STUDENTS_AGE CHECK (AGE > 0) -- Constraint to ensure age is positive
);

-- Table: STUDENT_CLASSES
-- Stores the relationship between students and the classes they are enrolled in.
CREATE TABLE IF NOT EXISTS STUDENT_CLASSES
(
    STUDENT_ID       VARCHAR(20),             -- Reference to the student
    CLASS_ID         VARCHAR(20),             -- Reference to the class
    CONSTRAINT UNQ_STDCLASS UNIQUE (STUDENT_ID, CLASS_ID), -- Unique constraint on the combination of student and class
    FOREIGN KEY(STUDENT_ID) REFERENCES STUDENTS(ID), -- Foreign key linking to the STUDENTS table
    FOREIGN KEY(CLASS_ID) REFERENCES CLASSES(CLASS_ID) -- Foreign key linking to the CLASSES table
);

-- Table: PARENTS
-- Stores information about parents of students.
CREATE TABLE IF NOT EXISTS PARENTS
(
    ID               VARCHAR(20) PRIMARY KEY, -- Unique identifier for each parent
    FIRST_NAME       VARCHAR(100) NOT NULL,   -- Parent's first name
    LAST_NAME        VARCHAR(100) NOT NULL,   -- Parent's last name
    GENDER           VARCHAR(10) CHECK (GENDER IN ('M', 'F', 'Male', 'Female')), -- Gender constraint
    ADDRESS_ID       VARCHAR(20),             -- Reference to parent's address
    CONSTRAINT FK_PARENTS_ADDR FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID) -- Foreign key linking to the ADDRESS table
);

-- Table: STUDENT_PARENT
-- Stores the relationship between students and their parents.
CREATE TABLE IF NOT EXISTS STUDENT_PARENT
(
    STUDENT_ID       VARCHAR(20),             -- Reference to the student
    PARENT_ID        VARCHAR(20),             -- Reference to the parent
    CONSTRAINT UNQ_STDPARENT UNIQUE (STUDENT_ID, PARENT_ID), -- Unique constraint on the combination of student and parent
    FOREIGN KEY(STUDENT_ID) REFERENCES STUDENTS(ID), -- Foreign key linking to the STUDENTS table
    FOREIGN KEY(PARENT_ID) REFERENCES PARENTS(ID) -- Foreign key linking to the PARENTS table
);

-- Modifying the STUDENTS table
-- The following statements demonstrate how to alter a table:
ALTER TABLE STUDENTS DROP COLUMN GRADE; -- Remove the GRADE column
ALTER TABLE STUDENTS ALTER COLUMN IS_ACTIVE TYPE VARCHAR(1); -- Change the data type of IS_ACTIVE to VARCHAR(1)
ALTER TABLE STUDENTS RENAME TO STUDENTS123; -- Temporarily rename the table
ALTER TABLE STUDENTS123 RENAME COLUMN IS_ACTIVE TO ACTIVE; -- Rename the IS_ACTIVE column to ACTIVE
ALTER TABLE STUDENTS123 RENAME TO STUDENTS; -- Restore the original table name
ALTER TABLE STUDENTS DROP COLUMN ACTIVE; -- Remove the ACTIVE column

-- Example Data Operations

-- Insert example addresses into the ADDRESS table
-- INSERT INTO ADDRESS VALUES
--     ('ADR1001','44940 Bluestem Circle','Baton Rouge','Louisiana','United States'),
--     ('ADR1002','029 Kropf Point','Richmond','Virginia','United States');

-- Retrieve all records from the ADDRESS table
SELECT * FROM ADDRESS;

-- Update the country for a specific address
UPDATE ADDRESS
SET COUNTRY = 'Malaysia'
WHERE ADDRESS_ID = 'ADR1005';

-- Retrieve the updated address
SELECT * FROM ADDRESS WHERE ADDRESS_ID = 'ADR1005';

-- Update multiple columns (Country and City)
UPDATE ADDRESS
SET COUNTRY = 'INDIA', CITY = 'AHMEDABAD'
WHERE ADDRESS_ID = 'ADR1005';

-- Delete all records where the country is 'Malaysia'
DELETE FROM ADDRESS WHERE COUNTRY = 'Malaysia';

-- Delete all records from the SCHOOL table
DELETE FROM SCHOOL;

-- Optional: Add a unique constraint to the STAFF table on STAFF_TYPE
-- ALTER TABLE STAFF ADD CONSTRAINT UNIQ_STF UNIQUE (STAFF_TYPE);
