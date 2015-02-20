require 'csv'

FILE_PATH = './tweets.csv'

CATS = {
  'Sports'        => %w(NBA Cristiano TwitterSports KDTrey5 carmeloanthony KingJames espn nfl RafaelNadal BillSimmons SportsCenter SHAQ),
  'Music'         => %w(shakira rihanna katyperry ladygaga jtimberlake BrunoMars taylorswift13 TwitterMusic justinbieber thalia selenagomez jesseyjoy),
  'Photography'   => %w(planetepics LIFE nasahqphoto Photoshop MeetAnimals HistoricalPics incredibleviews nytimesphoto CuteEmergency GettyImages Flickr),
  'Entertainment' => %w(stephenfry ActuallyNPH simonpegg twittermedia azizansari jimmyfallon TheEllenShow funnyordie JimCarrey YouTube JohnCleese),
  'Funny'         => %w(rickygervais rustyrockets TheOnion SethMacFarlane alyankovic),
  'News'          => %w(BBCBreaking TheEconomist Reuters CNN nytimes Forbes FoxNews BBCWorld nprnews),
  'Technology'    => %w(twitter TEDTalks BillGates lifehacker google WIRED ForbesTech TechCrunch gadgetlab TheNextWeb wired_business kaifulee),
  'Fashion'       => %w(CHANEL hm VictoriasSecret voguemagazine ninagarcia MarcJacobsIntl ELLEmagazine Burberry)
}

CSV.open('./tweets_with_cat.csv', 'wb') do |csv|

  inserted_header = false

  CSV.foreach(FILE_PATH, headers: :first_row) do |row|

    unless inserted_header
      csv << (row.headers << 'user_category')
      inserted_header = true
    end

    found = false

    CATS.each do |cat, names|
      if names.include? row['user_screen_name']
        csv << (row << cat)
        found = true
        break
      end
    end

    puts 'row not found in cats' if !found
  end

end
