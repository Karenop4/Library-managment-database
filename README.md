# Library Management System

## Description
This project involves designing the database for a library management system. The system must record information about books, authors, users, and the loans made. Through this exercise, a logical data model is created to represent the relationships between entities and their attributes.

## Database Structure
The database consists of the following main entities:

### 1. Authors
Contains information about the authors of the books.

- **Author ID**: Primary key, integer.
- **First Name**: Author's first name, text, required.
- **Last Name**: Author's last name, text, required.
- **Nationality**: Author's nationality, text, optional.
- **Date of Birth**: Author's date of birth, date, optional.

### 2. Books
Contains information about the books available in the library.

- **Book ID**: Primary key, integer.
- **Title**: Book title, text, required.
- **Publication Date**: Book publication date, date, optional.
- **Author ID**: Foreign key referencing the **Authors** entity.

### 3. Users
Contains information about the people who can borrow books.

- **User ID**: Primary key, integer.
- **First Name**: User's first name, text, required.
- **Last Name**: User's last name, text, required.
- **Email**: User's email address, text, unique and required.
- **Registration Date**: Date when the user registered in the system, date, required, defaults to current date.

### 4. Loans
Contains records of the loans made by the users.

- **Loan ID**: Primary key, integer.
- **User ID**: Foreign key referencing the **Users** entity.
- **Book ID**: Foreign key referencing the **Books** entity.
- **Loan Date**: Date when the loan is made, date, required, defaults to current date.
- **Return Date**: Date when the book is returned, date, optional.
