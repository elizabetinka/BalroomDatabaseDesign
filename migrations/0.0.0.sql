DROP TYPE IF EXISTS Dance;
CREATE TYPE Dance AS ENUM ('Медленный вальс', 'Танго', 'Венский вальс', 'Фокстрот', 'Квиксеп', 'Самба','Ча-ча-ча', 'Румба', 'Пасодобль', 'Джайв');


DROP TYPE IF EXISTS AgeCategory;
CREATE TYPE AgeCategory AS ENUM ('Дети 0', 'Дети 1', 'Дети 2', 'Юниоры 1', 'Юниоры 2', 'Молодежь','Взрослые', 'Сеньоры', 'Гранд-сеньоры');


DROP TYPE IF EXISTS SkillLevel;
CREATE TYPE SkillLevel AS ENUM ('H', 'E', 'D', 'C', 'B', 'A','S', 'M');


DROP TYPE IF EXISTS СompetitionsProgram;
CREATE TYPE СompetitionsProgram AS ENUM ('Стандарт', 'Латина', 'Двоеборье');


DROP TYPE IF EXISTS DancerType;
CREATE TYPE DancerType AS ENUM ('Пара', 'Соло');


DROP TYPE IF EXISTS Gender;
CREATE TYPE Gender AS ENUM ('Мужской', 'Женский');


DROP TYPE IF EXISTS ParticipantStatus;
CREATE TYPE ParticipantStatus AS ENUM ('Участник', 'Зритель');

CREATE TABLE IF NOT EXISTS Part (
    partID      integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    date_start   timestamptz NOT NULL,
    date_finish  timestamptz NOT NULL
);


CREATE TABLE IF NOT EXISTS Category (
    categoryID      integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    partId INTEGER NOT NULL,
    dancer_type   DancerType NOT NULL,
    competition_program  СompetitionsProgram NOT NULL,
    dance_count INTEGER NOT NULL,
    age_category AgeCategory NOT NULL,
    FOREIGN KEY (partId) REFERENCES Part (partID)
);


CREATE TABLE IF NOT EXISTS DancerPerson (
    personID      integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    person_name   varchar(255),
    standart_level SkillLevel,
    latin_level SkillLevel,
    person_age INTEGER NOT NULL,
    gender Gender NOT NULL
);

CREATE TABLE IF NOT EXISTS Dancer (
    dancerID      integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    manId INTEGER,
    ladyId INTEGER,
    team   varchar(50),
    coach   varchar(255),
    FOREIGN KEY (manId) REFERENCES DancerPerson (personID),
    FOREIGN KEY (ladyId) REFERENCES DancerPerson (personID)
);


CREATE TABLE IF NOT EXISTS DancerCategory (
    categoryID      integer NOT NULL,
    dancerID      integer NOT NULL,
    PRIMARY KEY (categoryID, dancerID),
    FOREIGN KEY (categoryID) REFERENCES Category (categoryID),
    FOREIGN KEY (dancerID) REFERENCES Dancer (dancerID)
);

CREATE TABLE IF NOT EXISTS CategoriesLevels (
    categoryID      integer NOT NULL,
    skill_level      SkillLevel NOT NULL,
    PRIMARY KEY (categoryID, skill_level),
    FOREIGN KEY (categoryID) REFERENCES Category (categoryID)
);


CREATE TABLE IF NOT EXISTS DancerNumber (
    partID      integer NOT NULL,
    dancerID      integer NOT NULL,
    dancer_number integer UNIQUE NOT NULL,
    PRIMARY KEY (dancer_number, partID),
    FOREIGN KEY (partID) REFERENCES Part (partID),
    FOREIGN KEY (dancerID) REFERENCES Dancer (dancerID)
);

CREATE TABLE IF NOT EXISTS Judge (
    judgeID      integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    judge_name   varchar(255)
);

CREATE TABLE IF NOT EXISTS JudgeCategory (
    judgeID      integer NOT NULL,
    categoryID      integer NOT NULL,
    PRIMARY KEY (categoryID, judgeID),
    FOREIGN KEY (categoryID) REFERENCES Category (categoryID),
    FOREIGN KEY (judgeID) REFERENCES Judge (judgeID)
);

CREATE TABLE IF NOT EXISTS ProtocolStages (
    categoryID      integer NOT NULL,
    dancer_number     integer NOT NULL,
    dance    Dance NOT NULL,
    judgeID      integer NOT NULL,
    stage integer NOT NULL,
    cross_mark BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (categoryID, dancer_number, dance,judgeID,stage),
    FOREIGN KEY (categoryID) REFERENCES Category (categoryID),
    FOREIGN KEY (judgeID) REFERENCES Judge (judgeID),
    FOREIGN KEY (dancer_number) REFERENCES DancerNumber (dancer_number)
);

CREATE TABLE IF NOT EXISTS ProtocolFinal (
    categoryID      integer NOT NULL,
    dancer_number     integer NOT NULL,
    dance    Dance NOT NULL,
    judgeID      integer NOT NULL,
    stage integer NOT NULL,
    place_mark INTEGER NOT NULL,
    PRIMARY KEY (categoryID, dancer_number, dance,judgeID,stage),
    FOREIGN KEY (categoryID) REFERENCES Category (categoryID),
    FOREIGN KEY (judgeID) REFERENCES Judge (judgeID),
    FOREIGN KEY (dancer_number) REFERENCES DancerNumber (dancer_number)
);


CREATE TABLE IF NOT EXISTS Price (
    partID      integer NOT NULL,
    participant_status  ParticipantStatus NOT NULL,
    price INTEGER NOT NULL CHECK (price > 0),
    PRIMARY KEY (partID, participant_status),
    FOREIGN KEY (partID) REFERENCES Part (partID)
);

CREATE TABLE IF NOT EXISTS Ticket (
    partID      integer NOT NULL,
    ticket_token bytea PRIMARY KEY  NOT NULL,
    participant_status  ParticipantStatus NOT NULL,
    FOREIGN KEY (partID) REFERENCES Part (partID)
);

CREATE TABLE IF NOT EXISTS Music (
    music_link   varchar(255) PRIMARY KEY,
    dance Dance NOT NULL,
    min_level  SkillLevel DEFAULT 'H'
);

