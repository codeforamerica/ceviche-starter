module Languages
  class Generator < Jekyll::Generator
    def generate(site)
      print 'start with ', site.pages.length, " pages.\n"
      
      # Prepare a mapping from file name extensions to converters
      default_converter = site.getConverterImpl(Jekyll::Converters::Identity)
      converters = { }
    
      site.config['markdown_ext'].split(',').each do |ext|
        key = '.' + ext
        converters[key] = site.getConverterImpl(Jekyll::Converters::Markdown)
      end
      
      old_pages = site.pages.dup()
      old_pages.each do |old_page|
      
        if not old_page.data.include?('layout')
          # Skip anything that doesn't have a layout.
          next
        end
        
        converter = converters.fetch(old_page.ext.downcase(), default_converter)
      
        # Delete the initial page.
        print 'replace ' + old_page.path + ' --'
        site.pages.delete(old_page)
        
        site.config['languages'].each do |lang|
          iso_code = lang.keys[0]
          language = lang[iso_code]
          new_page1 = old_page.clone()
          
          # Assign a name like base.language.extension, compatible with Apache:
          # http://httpd.apache.org/docs/2.2/content-negotiation.html#naming
          new_page1.name = old_page.basename + old_page.ext + '.' + iso_code
          new_page1.process(new_page1.name)
          
          new_page1.data = old_page.data.clone()
          new_page1.data['language'] = language
          
          # For languages other than English, move the title and content.
          if iso_code != 'en'
            new_page1.data['title'] = old_page.data['title-' + iso_code]
            new_page1.content = converter.convert(old_page.data['body-' + iso_code] || '')
          else
            new_page1.content = converter.convert(old_page.content)
          end
          
          site.pages << new_page1
          print ' ' + new_page1.name
        end
        
        print "\n"
      end

      print 'end with ', site.pages.length, " pages.\n"
    end
  end
end
