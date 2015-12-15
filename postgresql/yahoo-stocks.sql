create table stocks (
    id serial primary key,
    name varchar(50),
    code integer,
    price real,
    created timestamp default CURRENT_TIMESTAMP
);
