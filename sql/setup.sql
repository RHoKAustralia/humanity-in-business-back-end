-- Create tables

-- Companies
create table if not exists companies
(
  id        serial not null
    constraint companies_pkey
    primary key,
  name      varchar(255),
  url       varchar(255),
  image_url varchar(255)
);

-- Users
create table if not exists users
(
  id  serial  not null
    constraint users_pkey
    primary key,
  full_name  varchar(255),
  email      varchar(255) not null unique,
  title      varchar(255),
  image_url  varchar(255),
  company_id integer
    constraint users_company
    references companies
    on delete cascade,
  password   varchar(255) not null
);

-- Challenges
create table if not exists challenges
(
  id             serial            not null
    constraint challenges_pkey
    primary key,
  title          varchar(255),
  description    text,
  location       varchar(255),
  challenge_date date,
  points         integer default 0 not null,
  image_url      varchar(255)
);

-- User Challenges
create table if not exists user_challenges
(
  id           serial  not null
    constraint user_challenges_pkey
    primary key,
  user_id      integer not null
    constraint fk_uc_user
    references users
    on update cascade on delete cascade,
  challenge_id integer not null
    constraint fk_uc_challenge
    references challenges
    on update cascade on delete cascade,
  completed    smallint default '0' :: smallint
);

-- Communities
create table if not exists communities
(
  id   serial       not null
    constraint communities_pkey
    primary key,
  name varchar(255) not null,
  description varchar(255),
  image_url varchar(255)
);

-- Events
create table if not exists events
(
  id           serial       not null
    constraint events_pkey
    primary key,
  name         varchar(255) not null,
  hours        integer,
  community_id integer      not null
    constraint events_communities_id_fk
    references communities
    on delete cascade,
  description  varchar(255),
  image_url    varchar(255),
  date         timestamp with time zone
);

-- Projects
create table if not exists projects
(
  id          serial       not null
    constraint projects_pkey
    primary key,
  name        varchar(255) not null,
  description varchar(255),
  owner       varchar(255),
  image_url   varchar(255)
);

-- Events <-> Projects (1..n <-> 1..n)
create table if not exists events_projects
(
  event_id   integer not null
    constraint events_fk
    references events
    on delete cascade,
  project_id integer not null
    constraint projects_fk
    references projects
    on delete cascade
);


-- Insert Data
INSERT INTO users (id, full_name, email, title, image_url, password) VALUES (1, 'Gandalf The Grey', 'gandalf@theshire.com', 'Wizard', 'https://uncledanny1979.files.wordpress.com/2010/03/gandalf.jpg', MD5('You should not pass'));

INSERT INTO communities(id, name, description, image_url) VALUES (1, 'The Community of the Ring', 'Save the Middle Earth', 'http://lotr.org/rivendell.jpg');

INSERT INTO events(id, name, hours, community_id, description, image_url, date) VALUES (1, 'The Rivendell assembly', 50, 1,'Save the Middle Earth', 'http://lotr.org/rivendell.jpg', '1954-07-29 00:00:00+00');

INSERT INTO projects(id, name, description, owner, image_url) VALUES (1, 'Save the Middle Earth', 'Destroy the ring', 'The Fellowship of the Ring', 'http://lotr.org/rivendell.jpg');

INSERT INTO events_projects(event_id, project_id) VALUES (1, 1)