require 'sqlite3'
require 'russian'

skype_user = ARGV[0]
skype_dir = ARGV[1].nil? ? File.join(Dir.home, '.Skype') : ARGV[1]

if skype_user.nil? 
    puts "Please, specify user`s Skype name as first argument!"
    exit 
end

skype_db = File.join(skype_dir, skype_user, 'main.db')

if not File.exists?(skype_db)
    puts "Can not find Skype database (tried '#{skype_db}')! You can specify full path to Skype directory as second argument."
    exit
end 

puts "Have started to analyze using: #{skype_db}..."

begin 

    db = SQLite3::Database.new(skype_db)
    db.results_as_hash = true

    select_sql = "SELECT displayname, given_displayname, skypename FROM Contacts"
    contacts = db.execute(select_sql)

    skypenames = []
    cases = []
    changes = []
    contacts.each do |contact|    
        given_name = contact['given_displayname'].nil? ? contact['displayname'] : contact['given_displayname']
        new_given_name = Russian.translit(given_name)

        if new_given_name != given_name
            cases.push("WHEN '#{contact['skypename']}' THEN '#{new_given_name}'")
            skypenames.push("'#{contact['skypename']}'")
            changes.push("'#{given_name}' -> '#{new_given_name}'")
        end
    end

    if skypenames.count > 0

        print "Read the changes and confirm them:"
        print changes.join("\n"), "\n"

        print "Do you confirm permutation? Type 'Yes' to confirm and anything else to abort: "
        user_input = STDIN.gets.chomp

        if user_input != "Yes"
            puts "Script has successfully aborted."
            exit 
        end 

        update_sql = "
            UPDATE Contacts
            SET 
                given_displayname = CASE skypename
                    #{cases.join(" ")}
                END
            WHERE skypename IN (#{skypenames.join(",")})
        "   
        db.execute(update_sql)

    else

        puts "Names which can be transliterated were not found."

    end 

rescue SQLite3::Exception => e 
    
    puts "Database exception: '#{e}'."        
    
ensure

    db.close if db

end