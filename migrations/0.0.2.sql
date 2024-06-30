/*show constraint_exclusion;*/



create table IF NOT EXISTS mans ( like DancerPerson including all );
alter table mans inherit DancerPerson;
alter table mans  add constraint partition_check check (gender = 'Мужской' );

create table IF NOT EXISTS ladyies ( like DancerPerson including all );
alter table ladyies inherit DancerPerson;
alter table ladyies add constraint partition_check check (gender = 'Женский');


