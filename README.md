#RottenTomatoes README

##Creating the Project README

In your project repository, add a file named README.md at the root. Required elements to include in the README for the project (see example):

How many hours did it take to complete?
~25 hours

Which required and optional stories have you completed?

Requirements:

Search results page
*Table rows should be dynamic height according to the content height
Custom cells should have the proper Auto Layout constraints. Done

*Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does). Done

*Filter page. Unfortunately, not all the filters are supported in the Yelp API.
The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
~implemented has some bugs

The filters table should be organized into sections as in the mock.
You can use the default UISwitch for on/off states. Optional: implement a custom switch
Radius filter should expand as in the real Yelp app
*Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list
Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.


