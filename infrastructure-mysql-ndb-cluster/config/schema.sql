drop table if exists user;

create table user (id bigint not null auto_increment, fullname varchar(255), password varchar(255), roles varchar(255), username varchar(255), primary key (id)) engine=ndb partition by key(id);