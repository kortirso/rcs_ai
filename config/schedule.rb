every 1.minute do
    runner 'User.check_challenges'
end

every 1.minute do
    runner 'User.check_games'
end