CREATE TABLE RAWDATA (
  Olympiad varchar(45),
  Discipline varchar(45),
  Competition varchar(80),
  Winner varchar(50),
  MedalType varchar(10),
  OlympicCity varchar(45),
  OlympicYear int(11),
  OlympicSeason varchar(45),
  Gender varchar(10),
  CommitteeCode varchar(5),
  Committee varchar(45),
  CommitteeType varchar(45)
);

CREATE TABLE OLYMPIAD(
	Olympiad varchar(45) NOT NULL,
    OlympicCity varchar(45),
    OlympicYear int(11),
    OlympicSeason varchar(45),
    CONSTRAINT OlympiadPK PRIMARY KEY(Olympiad)
);

CREATE TABLE COMPETITION(
	CompetitionID INT NOT NULL AUTO_INCREMENT,
	Competition varchar(80),
    Discipline varchar(45),
    Gender varchar(45),
    CONSTRAINT CompetitionPK PRIMARY KEY(CompetitionID)
);

CREATE TABLE COUNTRY(
	CommitteeCode varchar(5) NOT NULL,
    Committee varchar(45),
    CommitteeType varchar(45),
    CONSTRAINT CommitteePK Primary Key(CommitteeCode)
);

CREATE TABLE ATHLETE(
	AthleteID INT NOT NULL AUTO_INCREMENT,
	Winner varchar(45),
    CommitteeCode varchar(5),
    CONSTRAINT AthletePK Primary Key(AthleteID)
);

CREATE TABLE MEDAL(
	MedalID INT NOT NULL AUTO_INCREMENT,
	MedalType varchar(10),
    CONSTRAINT MedalPK Primary Key(MedalID)
);

CREATE TABLE OLYMPIAD_EVENT(
	OlympiadEventID INT NOT NULL AUTO_INCREMENT,
    Olympiad varchar(45),
    CompetitionID INT,
    CONSTRAINT OlympiadEventPK Primary Key(OlympiadEventID)
);

CREATE TABLE COMPETITON_MEDAL(
	OlympiadEventID INT NOT NULL,
    MedalID INT NOT NULL,
    AthleteID INT,
    CONSTRAINT CompetitionMedalPK Primary Key(OlympiadEventID, MedalID)
);

SELECT COUNT(*)
FROM RAWDATA;

ALTER TABLE RAWDATA
ADD AthleteID INT,
ADD MedalID INT,
ADD CompetitionID INT;

INSERT INTO OLYMPIAD_EVENT (Olympiad, CompetitionID)
SELECT Olympiad, COMPETITION.CompetitionID
FROM RAWDATA JOIN COMPETITION ON RAWDATA.Competition = COMPETITION.Competition;




SELECT OE.OlympiadEventID, M.MedalID, A.AthleteID
FROM RAWDATA R JOIN MEDAL M ON R.MedalType = M.MedalType 
JOIN ATHLETE A ON R.Winner = A.Winner
JOIN COMPETITION C ON R.Competition = C.Competition 
JOIN OLYMPIAD_EVENT OE ON OE.CompetitionID = C.CompetitionID AND OE.Olympiad = R.Olympiad;

SELECT ATHLETE.AthleteID, MEDAL.MedalID
FROM ATHLETE
JOIN RAWDATA ON ATHLETE.Winner = RAWDATA.Winner
JOIN MEDAL ON MEDAL.MedalType=RAWDATA.MedalType;

CREATE TABLE ATHLETE_MEDAL(
	AthleteMedalID INT NOT NULL AUTO_INCREMENT,
	AthleteID INT,
    MedalID INT,
    CONSTRAINT AthleteMedalPK Primary Key(AthleteMedalID));

INSERT INTO ATHLETE_MEDAL (AthleteID, MedalID)
SELECT ATHLETE.AthleteID, MEDAL.MedalID
FROM ATHLETE
JOIN RAWDATA ON ATHLETE.Winner = RAWDATA.Winner
JOIN MEDAL ON MEDAL.MedalType = RAWDATA.MedalType;

CREATE VIEW AthleteCountryView AS
SELECT COUNTRY.Committee, ATHLETE.Winner, MEDAL.MedalType
FROM COUNTRY
JOIN ATHLETE ON COUNTRY.CommitteeCode = ATHLETE.CommitteeCode
JOIN ATHLETE_MEDAL ON ATHLETE.AthleteID = ATHLETE_MEDAL.AthleteID
JOIN MEDAL ON ATHLETE_MEDAL.MedalID = MEDAL.MedalID;

CREATE VIEW OlympiadEventView AS
SELECT OLYMPIAD.Olympiad, OLYMPIAD.OlympicSeason, COMPETITION.Competition, COMPETITION.Discipline, COMPETITION.Gender
FROM OLYMPIAD
JOIN OLYMPIAD_EVENT ON OLYMPIAD.Olympiad = OLYMPIAD_EVENT.Olympiad
JOIN COMPETITION ON OLYMPIAD_EVENT.CompetitionID = COMPETITION.CompetitionID;
    