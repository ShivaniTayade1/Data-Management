#1 List the trip name of each trip that has the season Late Spring
select TripName
from COLONIAL.Trip
where Season = 'Late Spring';

#List the trip name of each trip that is in the state of Vermont (VT) or that has a maximum group size greater than 10.
select TripName
from COLONIAL.Trip
where State= 'VT' and MaxGrpSize >10 ;

#3List the trip name of each trip that has the season Early Fall or Late Fall.
select TripName
from COLONIAL.Trip
where Season= 'Early Fall' or Season = 'Late Fall' ;

#4How many trips are in the states of Vermont (VT) or Connecticut (CT)?
select State,
Count(TripID) as Num_of_trips
from COLONIAL.Trip
where State= 'VT' or State= 'CT' 
group by State;
#or

select
Count(TripID) as Num_of_trips
from COLONIAL.Trip
where State= 'VT' or State= 'CT';

#5List the name of each trip that does not start in New Hampshire (NH).
select TripName
from COLONIAL.Trip
where State != 'NH';

#6List the name and start location for each trip that has the type Biking.
select TripName, StartLocation
from COLONIAL.Trip
where Type = 'Biking';

/*7List the name of each trip that has the type Hiking and that has a distance of greater than six miles.
 Sort the results by the name of the trip.*/
select TripName
from COLONIAL.Trip
where Type = 'Hiking' and Distance > 6;

 #8List the name of each trip that has the type Paddling or that is located in Vermont (VT).
select TripName
from COLONIAL.Trip
where Type = 'Paddling' and State = 'VT';

#9 How many trips have a type of Hiking or Biking?
select 
count(TripID)
from COLONIAL.Trip
where Type = 'Hiking' or Type = 'Biking';

#10List the trip name and state for each trip that occurs during the Summer season. Sort the results by trip name within state.
select TripName, State
from COLONIAL.Trip
where Season = 'Summer'
order by State, TripName;

#11List the trip name of each trip that has Miles Abrams as a guide.
select TripName
from COLONIAL.Trip as a
left join COLONIAL.Guide as b 
on a.State=b.State  
where FirstName = 'Miles' and LastName = 'Abrams';

#12 List the trip name of each trip that has the type Biking and that has Rita Boyers as a guide.
select a.TripName
from COLONIAL.Trip as a
left join COLONIAL.Guide as b 
on a.State=b.State  
where Type= 'Biking' and FirstName = 'Rita' and LastName = 'Boyers';

#13For each reservation that has a trip date of July 23, 2018, list the customer’s last name, the trip name, and the start location.
select a.TripName, a.StartLocation, b.LastName
from COLONIAL.Trip as a
left join COLONIAL.Customer as b
on a.State=b.State
left join 
(select TripID, TripDate
from COLONIAL.Reservation
where TripDate='2018-07-23') as c
on a.TripID = c.TripID;

#14How many reservations have a trip price that is greater than $50.00 but less than $100.00?
select
count(ReservationID)
from COLONIAL.Reservation
where tripPrice between 50 and 100;

#15. For each reservation with a trip price of greater than $100.00, list the customer’s last name, the trip name, and the trip type.
select a.TripName, a.Type, b.LastName
from COLONIAL.Trip as a
left join COLONIAL.Customer as b
on a.State=b.State
left join 
(select TripID, TripDate
from COLONIAL.Reservation
where TripPrice > 1000) as c
on a.TripID = c.TripID;

#16List the last name of each customer who has a reservation for a trip in Maine (ME).
select b.LastName
from COLONIAL.Trip as a
left join COLONIAL.Customer as b
on a.State=b.State
inner join 
(select TripID, TripDate
from COLONIAL.Reservation
) as c
on a.TripID = c.TripID
where a.State= 'ME';

#17How many trips originate in each state? Order the results by the state.
select State,StartLocation,
count(TripID)
from COLONIAL.Trip
group by 1,2
order by 1,2;

/*18 List the reservation ID, customer last name, and the trip name for all reservations
 where the number of persons included in the reservation is greater than four.*/
select a.ReservationID, b.LastName, c.TripName
from COLONIAL.Trip as a
left join COLONIAL.Customer as b
on a.State=b.State
inner join 
(select TripID, TripDate
from COLONIAL.Reservation
) as c
on a.TripID = c.TripID

 
-- 19. List the trip name, the guide’s first name, and the guide’s last name for all trips that originate in New Hampshire (NH). 
-- Sort the results by guide’s last name within trip name.

-- 20. List the reservation ID, customer number, customer last name, and customer first name for all trips that occur in July 2018.
/*21. Colonial Adventure Tours calculates the total price of a trip by adding the trip price plus other fees and multiplying
--  the result by the number of persons included in the reservation. List the reservation ID, trip name, customer’s last name, 
customer’s first name, and total cost for all reservations where the number of persons is greater than four.
 Use the column name TotalCost for the calculated field.*/
 
 
-- 22. List all customers whose first name starts with L or S. Sort the results by FirstName.
-- 23. List all the trip names whose prices are between $30 and $50.
-- 24. Write a query to determine how many trips have prices between $30 and $50.
 -- (Please note that this question is different from number 23 above.)
-- 25. Display the trip ID, trip name, and reservation ID for all trips that do not yet have the reservations.
-- 26. List the trip information for each pair of trips that have the same start location.
-- 27. List information for each customer that either lives in the state of New Jersey (NJ), or that currently has a reservation, or both.
-- 28. Display all guides who are not currently assigned to any trips.
-- 29. Display the guide information for each pair of guides that come from the same state.
-- 30. Display the guide information for each pair of guides that come from the same city.