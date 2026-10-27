# Rasid : stock, achats et ventes

Application de gestion de stock pour un commerce : articles avec prix d'achat et de vente,
achats fournisseurs, ventes avec facture PDF (TVA, ICE), valeur du stock au coût moyen pondéré,
marge, clients et fournisseurs, crédit, inventaire. Elle fonctionne sur PC et sur téléphone,
même sans internet, et s'installe comme une application.

**Une copie par client** : chaque client a sa propre base Supabase et sa propre adresse.
Ses données ne sont jamais mélangées avec celles d'un autre client.

## Installer pour un nouveau client

### 1. La base de données (Supabase)

1. Sur https://supabase.com, créez un projet **au nom du client** (région Europe).
   Le plan gratuit accepte 2 projets actifs par compte : pour plusieurs clients, créez un compte
   Supabase par client (idéalement avec l'e-mail du client, qui reste propriétaire de ses données).
2. **SQL Editor** › **New query** : collez tout `supabase.sql`, puis **Run**.
3. **Authentication** › **Sign In / Providers** : désactivez **Allow new users to sign up**.
4. **Authentication** › **Users** › **Add user** › **Create new user** : un compte par personne
   (gérant, vendeur…), avec **Auto Confirm User** coché.
5. **Project Settings** › **API Keys** › onglet **Legacy** : copiez la clé **anon public**
   et l'adresse du projet (`https://xxxx.supabase.co`).

### 2. Le fichier config.js

```js
window.SUPA_URL = "https://xxxx.supabase.co";
window.SUPA_KEY = "eyJhbGciOi...";
```

Ne mettez jamais la clé **service_role** dans ce fichier.

### 3. La mise en ligne (GitHub Pages)

1. Créez un dépôt par client, par exemple `rasid-epicerie-atlas`, en **Public**.
2. Envoyez-y **tous les fichiers de ce dossier** (avec `config.js` rempli pour ce client).
3. **Settings** › **Pages** › Deploy from a branch › `main` › `/ (root)` › **Save**.
4. Adresse du client : `https://<votre-compte>.github.io/rasid-epicerie-atlas/`

### 4. Premier démarrage chez le client

Le tableau de bord guide en 4 étapes :
1. **Mon entreprise** : nom, adresse, ICE, RC, IF, patente, logo, TVA par défaut ;
2. **Catégories** (cocher « Lots et péremption » pour les produits à date limite) ;
3. **Articles** : un par un, ou avec le **modèle Excel** (menu Données) puis **Importer** ;
4. **Stock de départ** : onglet **Inventaire** (ou colonne « Stock initial » du modèle Excel).

Le bouton **Charger des données d'exemple** permet de faire une démonstration ;
**Données › Effacer toutes les données** remet ensuite l'application à zéro.

## Version sans serveur

`Rasid.html` (fourni à part) contient toute l'application dans un seul fichier, sans compte ni
internet. Les données restent dans le navigateur du PC : idéal pour une démonstration ou un
petit commerce avec un seul poste. Faire une **Sauvegarde complète** chaque semaine.

## Mettre à jour un client

Remplacez `index.html` (et `sw.js` s'il a changé) dans son dépôt. Les données, dans Supabase,
ne changent pas. Chaque appareil recharge une fois la page avec internet.

## Caisse, code-barres, remises et devis

- **Douchette USB** : dans une vente, un achat ou un devis, le curseur est dans le champ « Scanner ».
  Chaque code lu ajoute l'article (ou +1 s'il est déjà dans la liste). Le code doit être saisi
  dans la **Référence / code-barres** de l'article.
- **Caméra** : bouton 📷 dans les formulaires, la fiche article et l'onglet Articles. Fonctionne sur
  Chrome Android (et Chrome sur Mac) avec la version en ligne (adresse https).
- **Ticket de caisse** : bouton 🧾 sur chaque vente. Largeur 58 ou 80 mm et impression automatique
  après chaque vente : menu Données › Mon entreprise. L'imprimante thermique doit être installée
  comme imprimante du PC (choisir « Aucune marge » dans la fenêtre d'impression si besoin).
- **Monnaie à rendre** : en espèces, saisir le « Montant reçu » ; le rendu s'affiche et s'imprime.
- **Remises** : par ligne (%) et globale (% ou montant). La remise globale est répartie sur les lignes
  pour garder une TVA juste par taux.
- **Devis** (DV-2026-0001…) : n'affectent pas le stock ; bouton « Transformer en facture » quand le
  client accepte. Validité par défaut : 30 jours (réglable dans Mon entreprise).

## Bon à savoir

- Prix d'achat en **HT**, prix de vente en **TTC** (comme en caisse) ; la marge est calculée sur le HT.
- La valeur du stock et le coût des ventes utilisent le **coût moyen pondéré** (CUMP).
- Numérotation : factures `FA-2026-0001`, bons de réception `BR-2026-0001`.
- Hors ligne, deux appareils qui vendent en même temps peuvent produire le même numéro de facture.
- Le plan gratuit de Supabase met en pause un projet resté 7 jours sans activité
  (réactivation en un clic, données conservées).
