class TextileLite

  def process(text)
    @text = text.to_s
    @html = []
    @text.gsub!(/(\r\n|\n|\r)/, "\n")
    @text.gsub!(/\n\n+/, "\n\n")
    process_blocks
    @html.join("\n\n")
  end

  BLOCK_PATTERN = /^([ph])([1-9])?(\(([^\)]+)\))?\. /

  def process_blocks
    # 
    block_pattern = /^([ph])([1-9])?\.([a-z0-9_-]+)? /
    #
    @blocks = @text.split(/\n\n/)
    @blocks.each do |block|
      lines = block.split(/\n/)
      # Determine the type of block
      if block =~ BLOCK_PATTERN
        lines.first.gsub! BLOCK_PATTERN, ''
        block_method = case $1
          when 'p'
            paragraph(lines, $4)
          when 'h'
            heading(lines, $2, $4)
        end
      elsif lines.all? {|line| line =~ /^# /}
        ordered_list(lines)
      elsif lines.all? {|line| line =~ /^\* /}
        unordered_list(lines)
      else
        paragraph(lines, $4)
      end
    end
  end

  def paragraph(lines, css_class = nil)
    text = process_text(lines)
    @html << content_tag('p', text, :css_class => css_class)
  end
  
  def heading(lines, level = 1, css_class = nil)
    text = process_text(lines)
    @html << content_tag("h#{level}", text, :css_class => css_class)
  end
  
  def unordered_list(lines, css_class = nil)
    @html << content_tag('ul', list_items(lines).join("\n"), :css_class => css_class)
  end

  def ordered_list(lines, css_class = nil)
    @html << content_tag('ol', list_items(lines).join("\n"), :css_class => css_class)
  end

  def list_items(lines)
    lines.map do |line|
      line.gsub!(/[\*#] /,'')
      content_tag('li', inline_formatting(line))
    end    
  end

  def process_text(lines)
    text = linebreaks(lines)
    text = inline_formatting(text)
    text
  end
  
  def inline_formatting(text)
    # links
    text.gsub!(/"([^"]+)":([^\s]+)/) {|s| "<a href=\"#{$2}\">#{$1}</a>" }
    # bold and italic
    inline_wrap(text, '\*', '<strong>', '</strong>')
    inline_wrap(text, '_', '<em>', '</em>')
    # quotes, elipsis etc.
    inline_textile_glyphs(text)
    text
  end
  
  def inline_wrap(text, delimiter, left, right = nil)
    right = left if right.nil?
    pattern = Regexp.new("#{delimiter}([^#{delimiter}]+)#{delimiter}")
    text.gsub!(pattern) {|s| "#{left}#{$1}#{right}"}
  end

  def linebreaks(lines)
    lines = lines.join("<br />\n") if lines.is_a? Array
    lines
  end

  def content_tag(tagname, contents, options = {})
    html  = "<#{tagname}"
    if options[:css_class]
      html << ' class="' + options[:css_class]  + '"'
    end
    html << ">"
    html << contents
    html << "</#{tagname}>"
  end

  OFFTAGS = /(code|pre|kbd|notextile)/
  OFFTAG_MATCH = /(?:(<\/#{ OFFTAGS }>)|(<#{ OFFTAGS }[^>]*>))(.*?)(?=<\/?#{ OFFTAGS }|\Z)/mi
  OFFTAG_OPEN = /<#{ OFFTAGS }/
  OFFTAG_CLOSE = /<\/?#{ OFFTAGS }/
  HASTAG_MATCH = /(<\/?\w[^\n]*?>)/m
  ALLTAG_MATCH = /(<\/?\w[^\n]*?>)|.*?(?=<\/?\w[^\n]*?>|$)/m

  def inline_textile_glyphs( text, level = 0 )
    if text !~ HASTAG_MATCH
        pgl text
    else
        codepre = 0
        text.gsub!( ALLTAG_MATCH ) do |line|
          ## matches are off if we're between <code>, <pre> etc.
          if $1
              if line =~ OFFTAG_OPEN
                  codepre += 1
              elsif line =~ OFFTAG_CLOSE
                  codepre -= 1
                  codepre = 0 if codepre < 0
              end 
          elsif codepre.zero?
              inline_textile_glyphs( line, level + 1 )
          else
              htmlesc( line, :NoQuotes )
          end
          #p [level, codepre, line]
          line
        end
    end
  end

  # Search and replace for Textile glyphs (quotes, dashes, other symbols)
  def pgl( text )
    GLYPHS.each do |re, resub|
        text.gsub! re, resub
    end
  end

  PUNCT = Regexp::quote( '!"#$%&\'*+,-./:;=?@\\^_`|~' )
  # Elements to handle
  GLYPHS = [
      [ /([^\s\[{(>])\'/, '\1&#8217;' ], # single closing
      [ /\'(?=\s|s\b|[#{PUNCT}])/, '&#8217;' ], # single closing
      [ /\'/, '&#8216;' ], # single opening
      [ /([^\s\[{(>])"/, '\1&#8221;' ], # double closing
      [ /"(?=\s|[#{PUNCT}])/, '&#8221;' ], # double closing
      [ /"/, '&#8220;' ], # double opening
      [ /\b( )?\.{3}/, '\1&#8230;' ], # ellipsis
      [ /\b([A-Z][A-Z0-9]{2,})\b(?:[(]([^)]*)[)])/, '<acronym title="\2">\1</acronym>' ], # 3+ uppercase acronym
      [ /(^|[^"][>\s])([A-Z][A-Z0-9 ]{2,})([^<a-z0-9]|$)/, '\1<span class="caps">\2</span>\3' ], # 3+ uppercase caps
      [ /(\.\s)?\s?--\s?/, '\1&#8212;' ], # em dash
      [ /\s->\s/, ' &rarr; ' ], # en dash
      [ /\s-\s/, ' &#8211; ' ], # en dash
      [ /(\d+) ?x ?(\d+)/, '\1&#215;\2' ], # dimension sign
      [ /\b ?[(\[]TM[\])]/i, '&#8482;' ], # trademark
      [ /\b ?[(\[]R[\])]/i, '&#174;' ], # registered
      [ /\b ?[(\[]C[\])]/i, '&#169;' ] # copyright
  ]

end
