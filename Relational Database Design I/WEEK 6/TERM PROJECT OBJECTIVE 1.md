## TERM PROJECT OBJECTIVE 1

Select one of your database ideas that your instructor has approved.

In a Word compatible document, provide a written description of the problem your database is intended to solve. Describe the situation in which your database will be used. This description can be similar to what you submitted previously but it should be detailed and clear of the objectives.

In the same Word document, create a list of the business rules that affect your database design. Keep in mind that business rules that specify many to many relationships between entities are fine. It is those business rules that imply an intersecting table will be needed to resolve the many to many relationship. You will likely need to add to your business rules as your design progresses so be sure to update your list of business rules to reflect any changes in your ERD.

Use Visio or a similar product to create an ERD of your database design. Your database design should be normalized to at least third normal form and include the following. It is expected that your database will consist of at least 8 tables and recommended that it has fewer than 20 tables. The ERD should show:
  - Table names
  - Primary and foreign keys
  - Identify cardinality for each relationship
  - Specify with action verbs the forward relationship in all one to many relationships
  - Resolve all many to many relationships

In the same Word document create your data dictionary as you did in Exercise 2 the first week of class. The data dictionary has the following information which may be shown using a Microsoft Word tables for each table in the ERD as was done in Exercise 2.
  - The columns names for each table. (If the business rules from exercise 1 didn’t define appropriate columns for a specific table, add some columns that seem logical to you.)
  - Give a description for each column.
  - Specify the primary and foreign keys
  - Specify the data type and size for each column. Select sizes that seem logical to you. Of course in a real world situation you would talk with users or look at documentation to determine the maximum size for a given column.
  - Specify what columns that are not primary or foreign keys must be UNIQUE (it will be assumed all other columns don’t have to be UNIQUE).
  - Specify what columns that are not primary or foreign keys cannot be NULL (it will be assumed all other columns can be NULL). Your project must have some columns that fit this.
  - Specify any fields that should be indexed (frequently queried attributes). Your project must have some indexes.
  - Specify default values for any columns where it seems to make sense. Your project must have some.
  - Add check constraints. For each constraint write a business rule. Your project must have some.
  - Specify Business Rules
