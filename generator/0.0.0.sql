CREATE OR REPLACE FUNCTION random_choice(
    choices int[]
)
RETURNS int AS $$
DECLARE
    size_ int;
BEGIN
    size_ = array_length(choices, 1);
    RETURN (choices)[floor(random()*size_)+1];
END
$$ LANGUAGE plpgsql;


INSERT INTO Part(date_start,date_finish)
SELECT
    '2000-08-22'::date + i*interval '12 hour',

    '2000-08-22'::date + (i+1)*interval '12 hour'
FROM GENERATE_SERIES(1, FLOOR(:'count'/3)::INTEGER) i;



INSERT INTO Category(partId,dancer_type, competition_program,dance_count,age_category)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count'/3)+1 )::INTEGER,
  (enum_range(NULL::DancerType))[random_choice(array[1,2])],
  (enum_range(NULL::СompetitionsProgram))[random_choice(array[1,2,3])],
    random_choice(array[2, 3, 4, 5, 6,8,10]),
    (enum_range(NULL::AgeCategory))[random_choice(array[1,2,3,4,5,6,7,8,9])]
FROM GENERATE_SERIES(1, FLOOR(:'count'/2)::INTEGER);

INSERT INTO DancerPerson(person_name,standart_level, latin_level,person_age,gender)
SELECT
    SUBSTR(md5(RANDOM()::text) ,0,255),
  (enum_range(NULL::SkillLevel))[random_choice(array[1,2,3,4,5,6,7,8])],
  (enum_range(NULL::SkillLevel))[random_choice(array[1,2,3,4,5,6,7,8])],
    FLOOR(RANDOM() *(100-1+1)+1 )::INTEGER,
    (enum_range(NULL::Gender))[random_choice(array[1,2])]
FROM GENERATE_SERIES(1, :'count');


INSERT INTO Dancer(manId,ladyId, team,coach)
SELECT
    NULLIF ((FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER),0),
    NULLIF (FLOOR(RANDOM() * (FLOOR(:'count')+1) )::INTEGER,0),
    SUBSTR(md5(RANDOM()::text) ,0,50),
    SUBSTR(md5(RANDOM()::text) ,0,255)
FROM GENERATE_SERIES(1, :'count');



INSERT INTO DancerCategory( categoryID, dancerID)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count'/2)+1 )::INTEGER,
    FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER
FROM GENERATE_SERIES(1, :'count')
ON CONFLICT ( categoryID, dancerID) DO NOTHING;



INSERT INTO CategoriesLevels( categoryID, skill_level)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count'/2)+1 )::INTEGER,
    (enum_range(NULL::SkillLevel))[random_choice(array[1,2,3,4,5,6,7,8])]
FROM GENERATE_SERIES(1, :'count')
ON CONFLICT ( categoryID, skill_level) DO NOTHING;


INSERT INTO DancerNumber ( partID , dancerID,dancer_number)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count'/3)+1 )::INTEGER,
     FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER,
     i
FROM GENERATE_SERIES(1, :'count') i
ON CONFLICT ( dancer_number , partID) DO NOTHING;


INSERT INTO Judge (judge_name )
SELECT
    SUBSTR(md5(RANDOM()::text) ,0,255)
FROM GENERATE_SERIES(1, :'count');


INSERT INTO JudgeCategory ( judgeID  , categoryID)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER,
     FLOOR(RANDOM() * FLOOR(:'count'/2)+1 )::INTEGER
FROM GENERATE_SERIES(1, :'count')
ON CONFLICT ( judgeID  , categoryID) DO NOTHING;


INSERT INTO ProtocolStages ( categoryID  , dancer_number,dance,judgeID,stage,cross_mark)
SELECT
     FLOOR(RANDOM() * FLOOR(:'count'/2)+1 )::INTEGER,
     FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER,
      (enum_range(NULL::Dance))[random_choice(array[1,2,3,4,5,6,7,8,9,10])],
      FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER,
      FLOOR(RANDOM() * 8+1 )::INTEGER,
      RANDOM() > 0.5
FROM GENERATE_SERIES(1, :'count') i
ON CONFLICT (  categoryID  , dancer_number,dance,judgeID,stage) DO NOTHING;


INSERT INTO ProtocolFinal ( categoryID  , dancer_number,dance,judgeID,stage,place_mark)
SELECT
     FLOOR(RANDOM() * FLOOR(:'count'/2)+1 )::INTEGER,
     FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER,
      (enum_range(NULL::Dance))[random_choice(array[1,2,3,4,5,6,7,8,9,10])],
      FLOOR(RANDOM() * FLOOR(:'count')+1 )::INTEGER,
      FLOOR(RANDOM() * 8+1 )::INTEGER,
       FLOOR(RANDOM() * 6+1 )::INTEGER
FROM GENERATE_SERIES(1, :'count') 
ON CONFLICT (  categoryID  , dancer_number,dance,judgeID,stage) DO NOTHING;



INSERT INTO Price ( partID , participant_status,price)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count'/3)+1 )::INTEGER,
    (enum_range(NULL::ParticipantStatus))[random_choice(array[1,2])],
     FLOOR(RANDOM() *(5000-100+1)+100 )::INTEGER
FROM GENERATE_SERIES(1, FLOOR(:'count'/3)::INTEGER)
ON CONFLICT ( partID , participant_status) DO NOTHING;


CREATE OR REPLACE FUNCTION random_bytea(bytea_length integer)
RETURNS bytea AS $body$
    SELECT decode(string_agg(lpad(to_hex(width_bucket(random(), 0, 1, 256)-1),2,'0') ,''), 'hex')
    FROM generate_series(1, $1);
$body$
LANGUAGE 'sql'
VOLATILE
SET search_path = 'pg_catalog';


INSERT INTO Ticket ( partID , participant_status,ticket_token)
SELECT
    FLOOR(RANDOM() * FLOOR(:'count'/3)+1 )::INTEGER,
    (enum_range(NULL::ParticipantStatus))[random_choice(array[1,2])],
    random_bytea(255)
FROM GENERATE_SERIES(1, FLOOR(:'count'/3)::INTEGER);

INSERT INTO Music ( music_link ,dance,min_level)
SELECT
    SUBSTR(md5(RANDOM()::text) ,0,255),
     (enum_range(NULL::Dance))[random_choice(array[1,2,3,4,5,6,7,8,9,10])],
   (enum_range(NULL::SkillLevel))[random_choice(array[1,2,3,4,5,6,7,8])]
FROM GENERATE_SERIES(1, FLOOR(:'count')::INTEGER);