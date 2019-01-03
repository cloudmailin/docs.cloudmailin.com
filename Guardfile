guard 'nanoc' do
  watch('nanoc.yaml') # Change this to config.yaml if you use the old config file name
  watch('Rules')
  watch(%r{^(content|layouts|lib)/.*$})
end

# guard 'shell' do
#   watch(%r{^(content|layouts|lib)/.*$}) do |filename|
#     puts "Altered #{filename}"
#     system %q{osascript -e "tell application \"Google Chrome\"
#       tell active tab of first window
#         execute javascript \"window.location.reload()\"
#       end tell
#     end tell"}
#   end
# end
