# DEFCON

An open-source community of [Firehose Project](http://thefirehoseproject.com) students.

## Wireframes

View the wireframes for this app [here](https://github.com/FirehoseCommunity/DEFCON/blob/master/Wireframes.md)

## Contributors

* Matthew Lepley
* Ken Mazaika
* Robert Sapunarich
* Cecelia Havens
* Amanda Mark
* Jeff Gerlach
* Justin Dizon

## Developer notes

[Firehose Cheat Sheet for working on existing projects](http://www.thefirehoseproject.com/cheat-sheets/working-on-existing-projects)

To use custom Rake tasks:
* "rake users:admin" without params will add a default "admin@fhpdefcontest.net" with password "awesomesauce"
* "rake users:admin[youremail,password]" NO SPACES because rake is quirky, will add an explicit admin user with the specified email and password. There is no email format validation here, it's just for seeding the database.
* "rake users:user" without params will add a default "user@fhpdefcontest.net" with password "awesomesauce"
* "rake users:user[email,password]" will add the explicit user.
* Can pass just an email to have password default to "awesomesauce"

If you're using Vagrant for your development environment start the server by running
`rails s -b 0.0.0.0`
instead of `rails server`.