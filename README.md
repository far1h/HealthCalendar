developed the calendar app into an automatic rescheduling calendar with openAI (recommendation) and healthKit integration as well as implemented a to-do list and streak system

![home2](https://github.com/far1h/HealthCalendar/assets/87598830/adc6a8f8-809d-4448-a260-750433562e49)
![home1](https://github.com/far1h/HealthCalendar/assets/87598830/4e7e3201-e892-4149-820c-b8e39e66b204)\n
Application Home Page: 
Users are welcome with their health stats at a glance with the option to see all, Recommendation events to be added to their Apple calendar, and ongoing and upcoming events from their Apple Calendar app.

![healthdetails](https://github.com/far1h/HealthCalendar/assets/87598830/68cd0caf-af01-4286-b374-cc136fb9fbd5)
Health Details: 
When users click see all, they can see more health stats that were not displayed on the home screen. The users can also click on the cards which will lead to the respective details in the Apple health app.

![healthapp](https://github.com/far1h/HealthCalendar/assets/87598830/a32ce4ab-99fc-4ebf-8029-2d6eb45d1d6f)
Apple Health App: 
Our application is integrated with the iOS built in health app through Healthkit and data is read and displayed in our application and used for many of it’s processes and functions

![openai2](https://github.com/far1h/HealthCalendar/assets/87598830/8ca1e87c-8c57-4518-875d-7af14870615b)
![openai1](https://github.com/far1h/HealthCalendar/assets/87598830/a25e8e59-83a6-4a63-be24-ef1647ebc536)
OpenAI Personalizd Recommendations: 
Our recommendation systems functions with the power of OpenAI GPT 3.5 turbo model using input such as common events in the user’s apple calendar, their health goals which can be set in the settings page, as well as their current health stats from the iOS health app. This allows for the recommendations to be personalized to the user.

![recomm3](https://github.com/far1h/HealthCalendar/assets/87598830/0887e7ff-2d1c-4577-850f-fee569212296)
![recomm2](https://github.com/far1h/HealthCalendar/assets/87598830/1c4126a1-3f88-4b6d-a224-519257e9487b)
![recomm1](https://github.com/far1h/HealthCalendar/assets/87598830/5335bd2f-2ed2-4705-8bf0-7b2f73374c3d)
Adding Recommendations and Conflicting events: 
When users accept the recommendation, they are asked to choose the time for the event to be scheduled and in cases where there is an event at the same time, they will be asked to either to choose an alternate time or add anyways


![activitypage2](https://github.com/far1h/HealthCalendar/assets/87598830/e62698a9-1e00-498a-b2e5-7c50d62194d2)
![activitypage1](https://github.com/far1h/HealthCalendar/assets/87598830/7b9891f2-b683-46d9-9e56-6b9ab667f697)
Activity Page and Calendar Page before rescheduling: 
The activity page of the app shows the daily events in list format. On this page as well, users have the choice to reschedule events that are conflicting. The calendar page provides users a better view of their daily events on their calendar.

![activitypage4](https://github.com/far1h/HealthCalendar/assets/87598830/f26e0f43-600e-4173-befc-fb11742c49a0)
![activitypage3](https://github.com/far1h/HealthCalendar/assets/87598830/809d3393-cbd3-420b-a1ce-ec3cf66981de)
Activity Page and Calendar Page after rescheduling: 
On the activity page, users can press the next button to iterate through events until they get to their desired one. Afterwards, users can press the reschedule button to change the start and end time of the conflicted event. This also allows users to decide which events should be reschedule and which shouldn’t.

![addevent2](https://github.com/far1h/HealthCalendar/assets/87598830/f70bbfc9-75d0-48a3-ae14-072e9f2597d4)
![addevent1](https://github.com/far1h/HealthCalendar/assets/87598830/c26987c4-b8da-4e8e-b4ab-6b39e58d4681)
Adding events: 
On the calendar page, users can create an event just like the Apple Calendar, inputting details such as the event name, location, timing, notes, etc. The events add on the calendar page will also be synced to the Apple Calendar app.

![activitydetails](https://github.com/far1h/HealthCalendar/assets/87598830/df414d9d-0339-49e8-bb20-39d2a0cb571c)
Event details page: 
Just like the Apple calendar app, users can press the event and see the details of the event such as it’s name, start and end times. They also have the option to delete the event, which when pressed, will also delete from the Apple calendar app.

![cal2](https://github.com/far1h/HealthCalendar/assets/87598830/43ad0e07-9f6f-4880-9590-857f075d7ded)
![cal1](https://github.com/far1h/HealthCalendar/assets/87598830/3f2670a7-6a68-43ea-9f06-57190557ed03)
Holding event to reschedule or check list: 
When users hold on the event, they can easily drag the edges or to change the start and end times, which works just like the Apple calendar app. However the differences are that it can also change the event title such that it will be checklisted.

![calapp](https://github.com/far1h/HealthCalendar/assets/87598830/feacb758-50e3-4dc8-b1a5-623de385a2cf)
Apple Calendar Integration: 
With all the changes made on the caledar page of our app, it will also be synced to the users Apple calendar app through EventKit. The Apple calendar app serves as a database for our application allowing us to create, read, update, and delete events.
   	
![progress3](https://github.com/far1h/HealthCalendar/assets/87598830/0230f48b-c258-4c42-aa4e-eef6c8479541)
![progress2](https://github.com/far1h/HealthCalendar/assets/87598830/29c48802-60df-4499-98ea-7d3852673013)
![progress1](https://github.com/far1h/HealthCalendar/assets/87598830/59574926-4998-4fa3-aff1-bf38b97dab18)
Progress and streaks page: 
On the progress page, users can choose on the health stats to view their progress towards their goals. When pressed, users will be shown the number of days they have successfully achieved their health goals. They can as well see the daily history of that specific health stats in a list format as well as a graph format.

![settings4](https://github.com/far1h/HealthCalendar/assets/87598830/d30cc4a8-f002-415b-b1ee-8cc51f00d315)
![settings3](https://github.com/far1h/HealthCalendar/assets/87598830/1894c803-a1c9-42c8-8187-74053f0a715f)
![settings2](https://github.com/far1h/HealthCalendar/assets/87598830/1a910b5a-2af2-4536-8c3b-8f683d24dc67)
![settings1](https://github.com/far1h/HealthCalendar/assets/87598830/6c5e8039-41cd-4ca5-a533-32844f221192)
Settings page: 
The settings page provides users with the freedom to make our app more personalized by inputting their health goals for steps, active calories, and more. They also have the option to upgrade to premium which have more features. 










