developed the calendar app into an automatic rescheduling calendar with openAI (recommendation) and healthKit integration as well as implemented a to-do list and streak system

Application Home Page: 
Users are welcome with their health stats at a glance with the option to see all, Recommendation events to be added to their Apple calendar, and ongoing and upcoming events from their Apple Calendar app.

Health Details: 
When users click see all, they can see more health stats that were not displayed on the home screen. The users can also click on the cards which will lead to the respective details in the Apple health app.

Apple Health App: 
Our application is integrated with the iOS built in health app through Healthkit and data is read and displayed in our application and used for many of it’s processes and functions
 
OpenAI Personalizd Recommendations: 
Our recommendation systems functions with the power of OpenAI GPT 3.5 turbo model using input such as common events in the user’s apple calendar, their health goals which can be set in the settings page, as well as their current health stats from the iOS health app. This allows for the recommendations to be personalized to the user.
   	
Adding Recommendations and Conflicting events: 
When users accept the recommendation, they are asked to choose the time for the event to be scheduled and in cases where there is an event at the same time, they will be asked to either to choose an alternate time or add anyways

Activity Page and Calendar Page before rescheduling: 
The activity page of the app shows the daily events in list format. On this page as well, users have the choice to reschedule events that are conflicting. The calendar page provides users a better view of their daily events on their calendar.
  	
Activity Page and Calendar Page after rescheduling: 
On the activity page, users can press the next button to iterate through events until they get to their desired one. Afterwards, users can press the reschedule button to change the start and end time of the conflicted event. This also allows users to decide which events should be reschedule and which shouldn’t.

Adding events: 
On the calendar page, users can create an event just like the Apple Calendar, inputting details such as the event name, location, timing, notes, etc. The events add on the calendar page will also be synced to the Apple Calendar app.

Event details page: 
Just like the Apple calendar app, users can press the event and see the details of the event such as it’s name, start and end times. They also have the option to delete the event, which when pressed, will also delete from the Apple calendar app.

Holding event to reschedule or check list: 
When users hold on the event, they can easily drag the edges or to change the start and end times, which works just like the Apple calendar app. However the differences are that it can also change the event title such that it will be checklisted.

Apple Calendar Integration: 
With all the changes made on the caledar page of our app, it will also be synced to the users Apple calendar app through EventKit. The Apple calendar app serves as a database for our application allowing us to create, read, update, and delete events.
   	
Progress and streaks page: 
On the progress page, users can choose on the health stats to view their progress towards their goals. When pressed, users will be shown the number of days they have successfully achieved their health goals. They can as well see the daily history of that specific health stats in a list format as well as a graph format.

Settings page: 
The settings page provides users with the freedom to make our app more personalized by inputting their health goals for steps, active calories, and more. They also have the option to upgrade to premium which have more features. 

