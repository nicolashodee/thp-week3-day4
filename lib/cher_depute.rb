require 'nokogiri'
require 'open-uri'

def init_nokogiri(url)
    print "Chargement de la page Web..."
    page = Nokogiri::HTML(open(url))
    return page
end

def main
    page = init_nokogiri("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique")
    # Si la page contient de données
    # --> Chercher sur le Web pour inclure les autres types d'erreurs
    if page != nil
        puts "Page Web chargée !"
        xpath_deputes = '//div[@id="deputes-list"]/div/ul/li/a[starts-with(text(), "M. ") or starts-with(text(), "Mme ")]'
        nbr_de_deputes = page.xpath(xpath_deputes).length
        array_deputes = creation_array(page, xpath_deputes, nbr_de_deputes)
    end
    p array_deputes
end

def recuperer_infos(lien_page_infos, n, nbr_de_deputes)
    page = init_nokogiri(lien_page_infos)
    # Si la page contient de données
    if page != nil
        puts "Page Web #{n+1}/#{nbr_de_deputes} chargée !"
        xpath_email = '//*[@class="deputes-liste-attributs"]/dd[4]/ul/li[2]/a[contains(text(), "@")]'
        return page.xpath(xpath_email).text
    end
end

def creation_array(page, xpath_deputes, nbr_de_deputes)
        array_deputes = Array.new
        (0..nbr_de_deputes-1).each { |n|
        # (553..554).each { |n| # Utiliser cette ligne à la place de la précédente pour tester les noms composés, apposés et à particules
            hash_tmp = Hash.new
            # Format du hash
            # "first_name" => "Prénom",
            # "last_name" => "Nom",
            # "email" => "prenom.nom@assemblee-nationale.fr"
            nom_complet_depute = page.xpath(xpath_deputes)[n].text.gsub(/^([M][\.][\s])|^([M][m][e])[\s]/, '').split(' ', 2)    # Pour les noms apposés et à particules : l'argument 2 est la limite, donc il va splitter une fois sur le premier \s afin d'obtenir 2 parties
            lien = page.xpath(xpath_deputes)[n]['href']
            lien = "http://www2.assemblee-nationale.fr#{lien}"
            email_depute = recuperer_infos(lien, n, nbr_de_deputes)
            hash_tmp["first_name"] = nom_complet_depute[0]
            hash_tmp["last_name"] = nom_complet_depute[1]
            hash_tmp["email"] = email_depute

            array_deputes << hash_tmp
            puts "Le hash #{hash_tmp} a été ajouté dans le tableau array_deputes"
        }
        return array_deputes
end

main