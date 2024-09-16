### Pet tracker Ruby on Rails API application 
---
REST API application that provides endpoints for managing information about pets and tracks number of pets outside of the zone.

#### Running the application:

###### 1. Setup database
```bash
bin/rails db:setup
```

###### 2. Run the server:
```bash
bin/rails server
```

To interact with application You can use postman collection provided in `docs/postman_collection`.

In other case you can use `curl` inside your terminal.

##### Create a pet:
```bash
curl -X POST http://localhost:3000/pets \
  -H "Content-Type: application/json" \
  -d '{"type":"Cat", "tracker_type":"medium","owner_id":1,"in_zone":false}'
```

##### Fetch pet:
```bash
curl -X GET http://localhost:3000/pets/1
```

##### Fetch list of pets:
```bash
curl -X GET http://localhost:3000/pets
```

##### Fetch list of pets that are out off zone:
```bash
curl -X GET http://localhost:3000/pets/off_zone
```

##### Update a pet:
```bash
curl -X PATCH http://localhost:3000/pets/1 \
  -H "Content-Type: application/json" \
  -d '{"type":"Cat", "in_zone":true}'
```

##### Delete a pet:
```bash
curl -X DELETE http://localhost:3000/pets/1
```

#### Running test:

In terminal run:
```bash
bundle exec rspec
```
