module Languages
  class Generator < Jekyll::Generator
    def generate(site)
      print 'start with ', site.pages.length, " pages.\n"
      
      old_pages = site.pages.dup()
      old_pages.each do |old_page|
      
        if not old_page.data.include?('layout')
          # Skip anything that doesn't have a layout.
          next
        end
      
        # Delete the initial page.
        print 'replace ' + old_page.path + ' --'
        #site.pages.delete(old_page)
        
        site.config['languages'].each do |lang|
          iso_code = lang.keys[0]
          language = lang[iso_code]
          new_page1 = old_page.clone()
          
          # Assign a name like base.language.extension, compatible with Apache:
          # http://httpd.apache.org/docs/2.2/content-negotiation.html#naming
          new_page1.name = old_page.basename + '.' + iso_code + old_page.ext
          new_page1.process(new_page1.name)

          new_page1.data = old_page.data.clone()
          new_page1.data['language'] = language
          
          # For languages other than English, move the title and content.
          if iso_code != 'en'
            new_page1.data['title'] = old_page.data['title-' + iso_code]
            new_page1.content = old_page.data['body-' + iso_code]
          end
          
          site.pages << new_page1
          print ' ' + new_page1.name

          if false
            new_page2 = old_page.clone()
          
            #
            new_page2.dir = iso_code + '/' + old_page.dir
            new_page2.process(new_page2.name)

            new_page2.data = old_page.data.clone()
            new_page2.data['language'] = language
          
            # For languages other than English, move the title and content.
            if iso_code != 'en'
              new_page2.data['title'] = old_page.data['title-' + iso_code]
              new_page2.content = old_page.data['body-' + iso_code]
            end

            site.pages << new_page2
            print ' ' + new_page1.name
          end
        end
        
        print "\n"
      end

      print 'end with ', site.pages.length, " pages.\n"
      
    end
  end
end
