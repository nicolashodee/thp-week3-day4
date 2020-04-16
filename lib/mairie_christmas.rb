=begin 
explication de nos variables et du raisonnement
>>  url_mairie                    #l'adresse de la page avec les infos de la mairie
>>  emplacement_url_mairie        #l'emplacement de l'url dans la page de l'annuaire avec toutes les mairies
>>  nom_mairie                    #le nom de la ville 
>>  emplacement_nom_mairie        #l'emplacement du nom de la ville dans la page de l'annuaire avec tous les noms
>>  email_mairie                  #l'email de la mairie
>>  emplacement_email             #l'emplacement de l'email dans la page de chaque mairie


***Etape 1: on lit les noms de mairies et les liens dans l'annuaire grace à get_townhall_url
***Etape 2: toujours dans la mm boucle, on lit l'email de chaque mairie dans sa page a l'adresse url_mairie
***Etape 3: on va ajouter l'email dans un hash du type hash_temporaire[nom_mairie] = email_mairie
***Etape 3: on delete les urls de l'array pour ne garder que les noms et emails
=end 


require 'pry'
require 'rubygems'
require 'nokogiri'
require 'open-uri'  
require_relative 'effacer_ligne'


### Fonction pour choper l'email dans la page de chaque mairie
def get_townhall_email(url_mairie)
  page = Nokogiri::HTML(open(url_mairie))
  emplacement_email = '/html[1]/body[1]/div[1]/main[1]/section[2]/div[1]/table[1]/tbody[1]/tr[4]/td[2]' 
  return page.xpath(emplacement_email).text
end


def get_townhall_url 
  page = Nokogiri::HTML(open('https://www.annuaire-des-mairies.com/val-d-oise.html')) #ouvre la page de l'annuaire avec toutes les communes
  emplacement_url_mairie = page.css("a.lientxt")                                      #donne la cible des liens avec la classe lientxt, en utilisant .css 
  (0..i_max-1).each { |n|   
    url_mairie = page.xpath(emplacement_url_mairie)[n]['href'].gsub(/^[\.]/, '')      #on attribue une valeur a nom_mairie en lisant la valeur a son emplacement, en specifiant qu'on cherche la cible du lien
  } 
  return url_mairie
  
def creation_array  
  emplacement_nom_mairie = '//a[@class="lientxt"]'                                    #donne l'emplacement des noms de mairies
  i_max = page.css("a.lientxt").length                                                #on donne la taille de l'array qui va stocker les infos 
  array_townhalls = Array.new                                                         #on definit l'array pour y mettre les valeurs qui seront lues 
  
  (0..i_max-1).each { |n|                                                             #on rentre dans une boucle pour commencer la "lecture"
    hash_temporaire = Hash.new 
    nom_mairie = page.xpath(emplacement_nom_mairie)[n].text.downcase                  #on attribue une valeur a nom_mairie en lisant la valeur a son emplacement
    
    url_mairie = "https://annuaire-des-mairies.com#{lien}"                            #on met a jour la variable avec un lien ok
    hash_temporaire[nom_mairie] = get_townhall_email(url_mairie)                      #on ajoute une nouvelle association dans notre hash en lisant l'email grace a l'url obtenue avant
    array_mairies << hash_tmp                                                         #on ajoute ce hash_temporaire a un tableau de taille i_max
    puts "On a ajoute le hash #{hash_temporaire} dans le tableau array_mairie"        #on affiche un message pour voir ce qui a ete ajoute
  }
  return array_mairies
end

get_townhall_url


