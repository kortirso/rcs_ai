every 2.minutes do
    runner 'User.check_challenges'
end

every 2.minutes do
    runner 'User.check_games'
end