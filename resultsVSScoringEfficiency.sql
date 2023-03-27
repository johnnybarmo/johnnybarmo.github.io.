--II-Analyzing how the goalscoring efficiency affected the final outcome of the game for the top 5 leagues in Europe (Seasons 2014-2015 till 2020-2021)
WITH conversionVSresults AS
(SELECT gameID
	  ,teams.name
      ,season
      ,goals
      ,xGoals
      ,result
	  ,"goalsConversion" = 
	  CASE
	  WHEN goals < xGoals THEN 'low'
	  WhEN goals >= xGoals THEN 'high'
	  END
	  ,"conversionImpact" = 
	  CASE
	  WHEN goals < xGoals AND result = 'W' THEN 'won despite poor finishing'
	  WHEN goals < xGoals AND result = 'L' THEN 'poor finishing lead to a loss'
	  WHEN goals < xGoals AND result = 'D' THEN 'drew despite poor finishing'
	  WhEN goals >= xGoals AND result = 'W' THEN 'efficient finishing lead to a win'
	  WhEN goals >= xGoals AND result = 'L' THEN 'lost despite the efficient finishing'
	  WhEN goals >= xGoals AND result = 'D' THEN 'drew despite the efficient finishing'
	  END
  FROM [FootballDatabase].[dbo].[teamstats]
  JOIN teams ON teams.teamID = teamstats.teamID)
  SELECT COUNT(*) AS totalTeamStatsAvailable
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'won despite poor finishing' ) AS wonDespitePoorFinishing
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'poor finishing lead to a loss' ) AS poorFinishingLeadToALoss
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'drew despite poor finishing' ) AS drewDespitePoorFinishing
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'efficient finishing lead to a win' ) AS efficientFinishingLeadToAWin
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'lost despite the efficient finishing' ) AS lostDespiteTheEfficientFinishing
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'drew despite the efficient finishing' ) AS drewDespiteTheEfficientFinishing
		,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'won despite poor finishing' )*100/COUNT(*) AS percWonDespitePoorFinishing
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'poor finishing lead to a loss' )*100/COUNT(*) AS percPoorFinishingLeadToALoss
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'drew despite poor finishing' )*100/COUNT(*) AS percDrewDespitePoorFinishing
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'efficient finishing lead to a win' )*100/COUNT(*) AS percEfficientFinishingLeadToAWin
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'lost despite the efficient finishing' )*100/COUNT(*) AS percLostDespiteTheEfficientFinishing
        ,(SELECT COUNT(*) FROM conversionVSresults WHERE conversionImpact = 'drew despite the efficient finishing' )*100/COUNT(*) AS percDrewDespiteTheEfficientFinishing
  FROM conversionVSresults