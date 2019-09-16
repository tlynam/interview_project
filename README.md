## Instructions

### Greetings intrepid adventurer!!

It's time to get prepared for your journey. We don't expect you to spend
more than 2 to 4 hours on this. To start we'll require a working ruby
installation with the bundler gem available. You may need to install
chromedriver as well.

* `bundle install`
* `rake db:create db:migrate db:seed`

You should now have a working application with some seed data installed.

When you're ready to start the server you may:

* `bundle exec rails s` and visit `http://localhost:3000/populations`

If you submit a year (eg, 1950), you'll be returned a population for the United
States at that particular time.

### Values

* Please reference the challenge in each git commit, eg `[CH-1]`.
* At each commit, tests should be passing.
* It's your house now, we expect you will want to refactor the code and schema.

### Challenge #1

When running `bundle exec rspec`, the test for Populations with the name:

* should accept a year that is after latest known and return the last known population

is far to slow.

Please debug and find a way to improve on the situation.

### Challenge #2

If you enter a few years into our form, you'll notice that we only return the
data that we know about. The responses for 1920, 1921, ... 1929 are all the same
until we reach 1930, which is our next real data point.

Please update the math so that between known data points, we see a linear
progression. For example, the response for 1955 should be 50% of the way between
1950 and 1960. Do not worry about time periods outside the range of our existing
data.

### Challenge #3

We're under attack! Someone from the security community just let us know that if
you visit

`http://localhost:3000/populations/by_year?year="><script>alert("XSS")</script>&`

Or enter: `"><script>alert("XSS")</script>&` into the year field for form, we're
vulnerable to a Cross-Site Scripting attack. NOTE: Chrome will block this by
default, you may want to try Firefox to reduce frustration.

This is terrible news, would you please take a crack at fixing?

### Challenge #4

Phew. We can sleep at night, but our customers are sick and tired of hitting the
back button when they need to check data for more than one year.

Please update the form so that after submitting input the results are returned
to the same page.

### Challenge #5

Emergency!! Our biggest client needs to know the population for 2045, but we
don't have any data for that. *And*, it's in the future. The CEO remembers a
a recent article they read about exponential growth models and suggested we try that.

Please update the application to be able to respond to queries after 1990,
using a exponential growth model for those years.

Some ideas:
* https://www.khanacademy.org/science/biology/ecology/population-growth-and-regulation/a/exponential-logistic-growth
* Assume a growth rate of 9% per year
* With this change, we plan to only support inquiries up to year 2500.

### Challenge #6

Our application is a hit now. Everyone loves seeing into the future! But folks
are reporting bugs and we can't really verify them because we don't know what
response the application gave them.

Please create a table in the database to record queries and answers. Also, we'll
want a dashboard for it up at `http://localhost:3000/the_logz` so that CEO can
read the results too.

### Challenge #7

CEO is confused by which of the query and responses are for real data or
computed data. We'll need to add that to the_logz.

Please update the_logz page to display which responses came from the database
and which were calculated mathematically. Call it "exact" vs "calculated"

### Challenge #8

Ugghhh. Data is a powerful thing. Now CEO wants to know which of the "exact"
years are the most popular. He seems to think that everyone wants to know about
1973, the year he was born. He also remembered a database lesson from a
conference he attended and said something about using a "JOIN".

Please add a table to the_logz that displays each of the years from the seed
data and how many requests have been made. Use "the JOINs".

### BONUS ROUND: Challenge #9

You'll never guess. CEO refreshed too often and sprained a finger. There's a
board meeting tonight (we only have one board member - the CEO). Regardless,
we need to get this thing real-time, so it can go up on a big screen in the
board room.

Please update the_logz page to pull fresh data every 10 seconds.

### DOUBLE BONUS ROUND: Challenge #10

Oh no! Our biggest client has threated to leave if we can't fix our prediction
model. They *claim*, that the United States can't support more than 750MM people
even in 2099. I think this means we need to support a logistic growth model as
well as the exponential growth model.

Please add a radio button to the form that specifies the growth model as either
exponential or logistic. Customers should only see the toggle if they enter a
year greater than 1990. In deference to our biggest client, the default should
be logistic.

### Todd's Notes
* Interesting that sqlite requires a default for null: false columns
  * calculation_type, :string, default: '', null: false
  * We can omit a default for a null: false column in postgres
* I would write more specs like for the service object methods but didn't have time
