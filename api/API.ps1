


##Get the league info
$league_id = 786392729767813120

$LeagueObject = Invoke-RestMethod -Method Get -Uri "https://api.sleeper.app/v1/league/$league_id"

$LeagueObject


#Get the rosters

$Rosters = Invoke-RestMethod -Method Get -Uri "https://api.sleeper.app/v1/league/$league_id/rosters"


#Get users

$Users = Invoke-RestMethod -Method Get -Uri "https://api.sleeper.app/v1/league/$league_id/users"

# Get 2022 rookie draft
$2022RookieDraft = 786392729767813121
$RookieDraft = Invoke-RestMethod -Method Get -Uri "https://api.sleeper.app/v1/draft/$2022RookieDraft"


$RookieDraftPicks = Invoke-RestMethod -Method Get -Uri "https://api.sleeper.app/v1/draft/$2022RookieDraft/picks"


# Get Player Info -- use only once per day

$Players = Invoke-RestMethod -Method Get -Uri "https://api.sleeper.app/v1/players/nfl"


# Current Taxi Squads

$TaxiSquads = @()

foreach ( $Roster in $Rosters) {
    $TaxiSquad = @()
    foreach ($taxiID in $Roster.taxi) {
        $TaxiPlayers = [PSCustomObject]@{
            Team = $( $Users | Where-Object { $_.user_id -EQ $Roster.owner_id }).display_name
            Player = $Players.$taxiID.full_name
            Exerience = $Players.$taxiID.years_exp
            ID = $Players.$taxiID.player_id
            RookieDraft = $($RookieDraftPicks | Where-Object {$_.player_id -EQ $Players.$taxiID.player_id}).round
        }
        $TaxiSquad += $TaxiPlayers

    }
    $TaxiSquads += $TaxiSquad
}

$TaxiSquads

Write-Host "Undrafted players on Taxi Squads:"
$TaxiSquads | Where-Object {$_.RookieDraft -EQ $null} | Format-Table