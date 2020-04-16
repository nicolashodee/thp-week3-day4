require 'nokogiri'
require 'open-uri'  # Obligatoire avec nokogiri pour charger une page sur le web
# require_relative 'effacer_ligne'

# page.xpath(XPATH)[n].text pointe vers le texte du n ème élément ayant comme xpath XPATH sur la page

def init_nokogiri(url)
    print "Chargement de la page Web..."
    page = Nokogiri::HTML(open(url))
    return page
end

def main
    page = init_nokogiri("https://coinmarketcap.com/all/views/all/")
    # Si la page contient de données
    if page != nil
        puts "Page Web chargée !"
        xpath_symbol = '//div[@class="cmc-table__table-wrapper-outer"]/div/table/tbody/tr[@class="cmc-table-row"]/td[contains(@class, "symbol")]'
        xpath_price = '//div[@class="cmc-table__table-wrapper-outer"]/div/table/tbody/tr[@class="cmc-table-row"]/td[contains(@class, "price")]'
        nbr_of_symbols = page.xpath(xpath_symbol).length
        array_crypto = creation_array(page, xpath_symbol, xpath_price, nbr_of_symbols)
        p array_crypto
    end
end

def creation_array(page, xpath_symbol, xpath_price, nbr_of_symbols)
  array_crypto = Array.new
  (0..nbr_of_symbols-1).each { |n|
      hash_tmp = Hash.new
      hash_tmp[page.xpath(xpath_symbol)[n].text] = page.xpath(xpath_price)[n].text.gsub(/[^\d\.]/, '')    # Ou pour supprimer uniquement $ et , : .delete('$,')
      array_crypto << hash_tmp
      puts "Le hash #{hash_tmp} a été ajouté dans le tableau array_crypto"
  }
  return array_crypto
end
 
main