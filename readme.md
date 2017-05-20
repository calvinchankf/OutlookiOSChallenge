#### Outlook iOS Challenge

Candidate: Kin Fung Chan(Calvin)  
Phone No.: +85261126075

This Project is to replicate the basic features described below of the Calendar and Agenda views on the Outlook iOS (iPhone) app.

#### Approach
Customize UICollectionView to the Calendar View and UITableView to the Agenda View. Deeply using UIScrollViewDelegate methods to handle the complicated scroll events.

Since users won't usually scroll to dates which long time ago/ahead from now, I decided to let users scroll within 6 years only(from 3 years ago to 3 years ahead) so that the number of days in the calendar is finite. It will be easier to handle.

#### File Struture
- Utilities
  - UIColorExtension
- Views
  - DayCell
  - AgendaCell
  - EmptyAgendaCell
  - AgendaHeader
- Models
  - DateModel <- date calculation
  - EventModel <- mock events
  - WeatherModel <- handle forecast network task
- ViewControllers
  - CalendarViewController
  - ProfileViewController <- about me

#### Features
- number of events is shown per day if any
- weather forecast using user's location

#### Unit Test
- mock data for `DateModel`
- mock data for `WeatherModel`

#### External libraries
None
