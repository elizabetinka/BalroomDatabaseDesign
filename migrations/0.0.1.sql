CREATE INDEX IF NOT EXISTS   ix_dancerID_DancerNumber ON DancerNumber (dancerID);
CREATE INDEX IF NOT EXISTS   ix_dancer_number ON DancerNumber (dancer_number);
CREATE INDEX IF NOT EXISTS  ix_manId ON Dancer  (manId);
CREATE INDEX IF NOT EXISTS  ix_ladyId ON Dancer  (ladyId);
CREATE INDEX IF NOT EXISTS   ix_dancerID_DancerCategory ON DancerCategory  (dancerID);
CREATE INDEX IF NOT EXISTS   ix_categoryID_DancerCategory ON DancerCategory  (categoryID);
CREATE INDEX IF NOT EXISTS   ix_partId ON Category  (partId);
CREATE INDEX IF NOT EXISTS  ix_dancer_number_stages ON ProtocolStages  (dancer_number);
CREATE INDEX IF NOT EXISTS  ix_categoryID_stages ON ProtocolStages  (categoryID);
CREATE INDEX IF NOT EXISTS   ix_dancer_number_final ON ProtocolFinal  (dancer_number);
CREATE INDEX IF NOT EXISTS  ix_categoryID_final ON ProtocolFinal  (categoryID);


CREATE INDEX IF NOT EXISTS  ix_partID_Ticket ON Ticket  (partID);


CREATE INDEX IF NOT EXISTS ix_judgeID ON JudgeCategory  (judgeID);

CREATE INDEX IF NOT EXISTS   ix_dance ON ProtocolStages  (dance);
CREATE INDEX IF NOT EXISTS  ix_cross_mark ON ProtocolStages  (cross_mark);
