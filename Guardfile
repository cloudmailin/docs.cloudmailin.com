guard 'shell' do
  watch (/(.*)(?:\.sass$|\.haml$|.md$)/) do |filename|
    puts "Altered #{filename}"
    system %q{osascript -e "tell application \"Google Chrome\"
      tell active tab of first window
        execute javascript \"window.location.reload()\"
      end tell
    end tell"}
  end
end