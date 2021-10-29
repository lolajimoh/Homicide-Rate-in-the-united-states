SELECT *
FROM Portfolio_Projects.dbo.HomicideVictim
ORDER BY 1


SELECT *
FROM Portfolio_Projects.dbo.HomicidePerpetrator
ORDER BY 1
-----------------------------------------------------------------------------------------------------------------------
--PULLING UP COLUMNS NEEDED FOR ANALYSIS

SELECT RecordID, CrimeType, CrimeSolved, VictimSex, VictimAge,VictimRace
FROM Portfolio_Projects.dbo.HomicideVictim
ORDER BY 1



SELECT RecordID, CrimeType, CrimeType, PerpetratorSex, PerpetratorAge,Relationship
FROM Portfolio_Projects.dbo.HomicidePerpetrator
ORDER BY 1

---------------------------------------------------------------------------------------------------------------------

--CHANGING RELATIONSHIP TO FAMILIAR AND UNFAMILIAR DEPENDING ON THE CONNECTION BTW VICTIM AND PERPETRATOR


SELECT RecordID, CrimeType, PerpetratorSex, PerpetratorAge, Relationship,
CASE
    WHEN Relationship = 'stranger' THEN 'Unfamiliar'
    ELSE 'Familiar'
END As RelationshipSorted
FROM Portfolio_Projects.dbo.HomicidePerpetrator
WHERE Relationship <> 'Unknown'
ORDER BY 1


--UPDATING HOMICIDE PERPETRATOR TABLE WITH THE NEW COLUMN


UPDATE Portfolio_Projects.dbo.HomicidePerpetrator
SET Relationship = CASE
    WHEN Relationship = 'stranger' THEN 'Unfamiliar'
    ELSE 'Familiar'
END 
WHERE Relationship <> 'Unknown'

----------------------------------------------------------------------------------------------------------------
--SHOWING TOTAL NUMBER OF CASES

SELECT Count(CrimeSolved) AS TotalSolved
From Portfolio_Projects.dbo.HomicideVictim


--SHOWING THE TOTAL NUMBER OF SOLVED CASES AND UNSOLVED CASES

SELECT CrimeSolved, Count(CrimeSolved) AS TotalSolved
From Portfolio_Projects.dbo.HomicideVictim
Group by Crimesolved


----------------------------------------------------------------------------------------------------------------------

-- SHOWING YEAR WITH HIGHEST NUMBER OF REPORTED CASES

SELECT DISTINCT (Year), CrimeSolved, COUNT(CrimeSolved) AS TotalCases
FROM Portfolio_Projects.dbo.HomicideVictim
GROUP BY Year, CrimeSolved
ORDER BY TotalCases Desc;

------------------------------------------------------------------------------------------------------------------------------

--SHOWING THE STATES WITH THE HIGHEST HOMICIDE RATE 

SELECT DISTINCT(state), CrimeSolved, COUNT(CrimeSolved) AS TotalCases
FROM Portfolio_Projects.dbo.HomicideVictim
GROUP BY state, CrimeSolved
ORDER BY TotalCases Desc;

-------------------------------------------------------------------------------------------------------------------------------
--SHOWING THE YEAR WITH THE HIGHEST CASE IN CALIFORNIA


SELECT State, CrimeSolved, COUNT(CrimeSolved) AS TotalCases, year
FROM Portfolio_Projects.dbo.HomicideVictim
GROUP BY state, CrimeSolved, Year
HAVING State = 'California'
ORDER BY TotalCases Desc;

-------------------------------------------------------------------------------------------------------------------------


--SHOWING THE NUMBER OF THE VICTIMS WHO KNEW THEIR KILLER

SELECT 
      VIC.RecordID, CrimeSolved, perpetratorSex, VictimSex, Relationship,
	  COUNT(Relationship) OVER(PARTITION BY Relationship) AS Totalknown
FROM Portfolio_Projects.dbo.HomicideVictim VIC
     JOIN Portfolio_Projects.dbo.HomicidePerpetrator PER
	 ON VIC.RecordID = PER.RecordID
WHERE Relationship <> 'Unknown'
ORDER BY 1



WITH CTE_HOMICIDE AS
(SELECT 
      VIC.RecordID, CrimeSolved, perpetratorSex, VictimSex, Relationship,
	  CAST(COUNT(Relationship) OVER(PARTITION BY Relationship)AS FLOAT) AS Totalknown,
	  CAST(Count(CrimeSolved) OVER(PARTITION BY CrimeSolved)AS FLOAT) AS TotalCases
FROM Portfolio_Projects.dbo.HomicideVictim VIC
     JOIN Portfolio_Projects.dbo.HomicidePerpetrator PER
	 ON VIC.RecordID = PER.RecordID
WHERE Relationship <> 'Unknown'
--ORDER BY 1
)
SELECT *,CAST((TotalCases/TotalKnown) AS FLOAT) AS Percentageknown
FROM CTE_HOMICIDE
ORDER BY 1





