## PROJECT IDEA SUBMISSION

For this assignment, you will need to come up with two to three database ideas. This can be a database that you may have dreamed about creating or one that you have previously worked on and have ideas of how it could be designed and constructed more efficiently. Keep in mind the focus of this term project is on designing and constructing a database along with appropriate Transact SQL procedures and functions. I will NOT accept a database idea that is not your own. That is, most of the tables, columns and data types will need to be unique to your database (not a copy from another database design). Be creative and have fun!

In a Word document, outline your project ideas with a heading, followed by a one or two paragraph description and purpose of the database and end with a list of tables that may be needed for each of your ideas. (Note: Don’t get too caught up on this part. Modifications and/or changes to the design are “par for the course”)

It is expected that your database will consist of at least 8 tables and recommended that it has fewer than 20 tables.

*IDEAS*

SCRUM database

  If you didn't know Scrum is a framework within which people can address complex adaptive problems, while productively and creatively delivering products of the highest possible value. Scrum itself is a simple framework for effective team collaboration on complex products and has multiple different forms but is commonly in a line progression format with columns.

  SCRUMs layout is as follows, the first column is where the task of the main project live. Then the next column is the "ice box" where the sub tasks are listed for each of those main tasks that were in the previous column. Then next there is the "emergency" column comes where very important sub tasks are put that weren't taken into account before hand and need to be completed before everything else. After that the "in progress" column is where the tasks from the "ice box" are when someone takes them and starts work. Then the "testing" column is where you put sub tasks that have been completed and are ready for integration approval. Then finally there is the "completed" column where all the completed tasks are.

  There will be one main account for the business and then the business will issue separate accounts to all there users. There will be options for users to have administrator access and then normal accounts where they can mark completion of a task, along with time, and move it from different categories. This will have a similar multi user system like GitHub has where you can work together to finish a project.

  So these will be the tables in the database: Business accounts, worker accounts, administrator accounts, tasks list, ice box, emergency, in progress, testing, completed. Now many of these tables will overlap with each other. For example every business account is connected to every other table list above in order to keep everything in the correct business account.

Student assignment database (pulls students from the same courses in Canvas and there assignments and then gives them other students assignments with high grades after due date.)

  This database will be an extension of sorts to the Canvas database. Now I have no idea what that database looks like for sure I can only assume but I'm guessing there are several tables with student, class, teacher, and assignment information.

  What I am proposing is that in order to combat the issue of students falling behind and not fully understanding assignments there will be a new function of the Canvas databases where high grade students assignments can be shown to students that got a low grade. This will be achieved by matching students with the class database, and then the assignment database along with the grade database. Then we will create a new database that takes in high grade assignments and stores them with labeled with the labeled class and assignment. Then when the assignment in question has been past its due date these "high grade" assignments can be shown to other students on the assignment page as an option.

Grocery store exchange database

  A common problem with grocery stores is that they order there product according to past trends and predicted futures. This can result in shorts of product or more commonly too much product. In order to solve this problem grocery stores can be setup to exchange product between themselves if they are short or have too much. This will be achieved by setting up a database to track overlaps, and since they already have databases for the product they have it wont be that challenging to list the products that they need or have already, that be the hardest part.

  In order to build this database there will be a business account list (including information about the store), then product list per business, then a list for each business with there needed and overflow product. Need and overflow would be there own lists.
