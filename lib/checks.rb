Nanoc::Check.define(:no_unprocessed_erb) do
  @output_filenames.each do |filename|
    if filename =~ /html$/ && File.read(filename).match?(/<%/)
      add_issue("unprocessed erb detected", subject: filename)
    end
  end
end

Nanoc::Check.define(:no_unprocessed_references) do
  EXPRESSION = /<p>.*\[.+\].*<\/p>\s/

  @output_filenames.each do |filename|
    if filename =~ /html$/ && File.read(filename).match?(EXPRESSION)
      match = File.read(filename).match(EXPRESSION)
      add_issue("unprocessed reference detected: #{match}", subject: filename)
    end
  end
end
