#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'uri'

## extract entries from dictionary
def extractEntries entries
  table = []
  entries.each do |entry|
    en = entry.css("side[lang='en'] words")
    de = entry.css("side[lang='de'] words")

    # join word if multiple
    if en.children.size > 1
      en = en.children.map{ |c| c.text }.join(", ")
    else
      en = en.text
    end

    if de.children.size > 1
      de = de.children.map{ |c| c.text }.join(", ")
    else
      de = de.text
    end

    table.push([en, de])
  end

  return table
end

###############################################################################
## Main

# stop if no argument is given
exit unless ARGV[0]

# query
doc = Nokogiri::XML(open(URI.encode("http://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=de&rmWords=off&rmSearch=on&search=#{ARGV[0]}&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16&n=1")))


# extract translations
table = []

## get translations

# extract best results
sections = doc.css("sectionlist[sectionsort='bestPrio']").children

# go through section
sections.each do |section|
  
  # get entries
  entries = section.css("entry")
  
  # show section title if we have entries
  if entries.size > 0
    table.push ["--- #{section["sctTitle"]}", ""] rescue table.push ["---", ""]
  end

  # extract translations
  table.concat extractEntries( entries )
end

## get synonyms
syn_en = doc.css("ffsynlist side[lang='en'] word").children.map { |e| e.text }
syn_de = doc.css("ffsynlist side[lang='de'] word").children.map { |e| e.text }
# transform for proper view
syn_max = [syn_en.size, syn_de.size].max
syn_en.fill("", syn_en.size...syn_max)
syn_de.fill("", syn_en.size...syn_max)
# add when there are some
if syn_en.size > 0 || syn_de.size >0
  table.push ["--- Synonyme EN", "--- Synonyme DE"]
  table.concat [syn_en, syn_de].transpose
end

# get max lenght of word
len_max = table.map{ |t| t.map{ |w| w.size rescue 0 } }.flatten.max

# print result
table.each do |t|
  printf "%-#{len_max}s %s\n", t[0], t[1]
end