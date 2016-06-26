every 1.minute do
    runner 'User.check_challenges'
end

every 10.seconds do
    runner 'User.check_games'
end