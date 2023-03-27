--I-Comparing the results VS the betting odds for the top 5 leagues in Europe (Seasons 2014-2015 till 2020-2021)
--Creating a view to simplify the analysis later on
CREATE VIEW resultsVSodds AS
WITH namingPrep AS     --CTE used to be able to join the same name column in the teams table to both the home and away teams IDs columns in the games table
(SELECT gameID
      ,games.leagueID
	  ,leagues.name AS league
      ,season
      ,homeTeamID
	  ,teams.name AS homeTeam
      ,awayTeamID
      ,homeGoals
      ,awayGoals
      ,B365H     --Odds as assigned by BET365
      ,B365D     --Odds as assigned by BET365
      ,B365A     --Odds as assigned by BET365
  FROM [FootballDatabase].[dbo].[games]
  JOIN leagues ON games.leagueID = leagues.leagueID    --To showcase the full league name
  JOIN teams ON games.homeTeamID = teams.teamID    --To showcase the full home team name
  )
  SELECT 
	   namingPrep.league
      ,namingPrep.season
	  ,namingPrep.homeTeam
	  ,teams.name AS awayTeam
      ,namingPrep.homeGoals
      ,namingPrep.awayGoals
      ,namingPrep.B365H AS homeOdds
      ,namingPrep.B365D AS drawOdds
      ,namingPrep.B365A AS awayOdds
	  ,"result" = CASE     --To showcase the accuracy of the pre-match assigned betting odds
      WHEN homeGoals = awayGoals THEN 'draw'
	  WHEN homeGoals > awayGoals AND B365H < B365A THEN 'favoriteWin'
	  WHEN homeGoals < awayGoals AND B365H > B365A THEN 'favoriteWin'
	  WHEN homeGoals > awayGoals AND B365H > B365A THEN 'underdogWin'
	  WHEN homeGoals < awayGoals AND B365H < B365A THEN 'underdogWin'
	  ELSE 'equalChanceWin'     --Case statements findings are in relation to pre-match betting odds
      END
  FROM namingPrep
  JOIN teams ON namingPrep.awayTeamID = teams.teamID    --To showcase the full away team name
  GROUP BY namingPrep.league
      ,namingPrep.season
	  ,namingPrep.homeTeam
	  ,teams.name
      ,namingPrep.homeGoals
      ,namingPrep.awayGoals
      ,namingPrep.B365H
      ,namingPrep.B365D
      ,namingPrep.B365A
--Full results table saved to be used later in visuals
SELECT COUNT(result) AS totalGames
       ,(SELECT COUNT(*) FROM resultsVSodds WHERE result = 'favoriteWin') AS favoriteWins
	   ,(SELECT COUNT(*) FROM resultsVSodds  WHERE result = 'underdogWin') AS underdogWins
	   ,(SELECT COUNT(*) FROM resultsVSodds  WHERE result = 'draw') AS draw
	   ,(SELECT COUNT(*) FROM resultsVSodds  WHERE result = 'equalChanceWin') AS equalChanceWins
	   ,(SELECT COUNT(*) FROM resultsVSodds WHERE result = 'favoriteWin')*100 / COUNT(*) AS favWinPerc
	   ,(SELECT COUNT(*) FROM resultsVSodds WHERE result = 'underdogWin')*100 / COUNT(*) AS undWinPerc
	   ,(SELECT COUNT(*) FROM resultsVSodds WHERE result = 'draw')*100 / COUNT(*) AS drawPerc
	   ,(SELECT COUNT(*) FROM resultsVSodds WHERE result = 'equalChanceWin')*100 / COUNT(*) AS equalChanceWinPerc
FROM resultsVSodds