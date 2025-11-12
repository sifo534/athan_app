# Athan Muslim - Complete Islamic Companion App

Une application mobile Flutter complète pour les musulmans, offrant tous les outils essentiels pour la pratique religieuse quotidienne.

## 🌟 Fonctionnalités

### 🕌 Page d'Accueil
- **Horaires de prière** en temps réel basés sur votre localisation GPS
- **Calendrier Hijri** avec conversion automatique
- **Salutations islamiques** adaptées à l'heure de la journée
- **Actualités islamiques** et rappels spirituels
- **Compte à rebours** jusqu'à la prochaine prière

### 🧭 Qibla Compass
- **Direction précise** vers la Kaaba à La Mecque
- **Boussole interactive** avec capteur magnétique
- **Interface élégante** avec indicateurs visuels
- **Instructions d'utilisation** intégrées

### 🛠️ Outils Islamiques
- **Mosque Finder** - Trouvez les mosquées à proximité
- **Halal Finder** - Restaurants et commerces halal
- **Dhikr Counter** - Compteur de dhikr numérique
- **Prayer Tracker** - Suivi des prières accomplies
- **Zakat Calculator** - Calculateur de zakat

### 🤲 Duas & Invocations
- **Collection complète** de duas authentiques
- **Catégories organisées** (quotidien, voyage, nourriture, etc.)
- **Texte arabe**, translittération et traduction
- **Fonction de recherche** avancée
- **Partage et copie** des duas

### 📖 Saint Coran
- **Lecture complète** du Coran
- **Audio de récitation** par différents récitateurs
- **Interface de lecture** optimisée
- **Recherche par sourate** ou mot-clé
- **Marque-pages** et historique de lecture

### 📅 Calendrier Hijri
- **Calendrier islamique** complet
- **Événements religieux** importants
- **Conversion automatique** grégorien/hijri
- **Interface calendrier** intuitive

### ⚙️ Paramètres
- **Thème sombre/clair** personnalisable
- **Choix du récitateur** d'Athan
- **Méthode de calcul** des horaires de prière
- **Notifications** configurables
- **Langues multiples** (à venir)

## 🎨 Design

L'application suit le design moderne visible dans l'image de référence :
- **Dégradé rose/violet** élégant
- **Ambiance islamique** avec silhouettes de mosquée
- **Cartes arrondies** avec ombres douces
- **Police Poppins** moderne et lisible
- **Icônes cohérentes** et intuitives

## 🔧 Technologies Utilisées

### Framework
- **Flutter** - Framework de développement mobile
- **Dart** - Langage de programmation

### Packages Principaux
- `geolocator` - Géolocalisation GPS
- `flutter_qiblah` - Direction Qibla
- `http` & `dio` - Requêtes API
- `flutter_local_notifications` - Notifications locales
- `audioplayers` - Lecture audio Athan/Coran
- `provider` - Gestion d'état
- `google_fonts` - Polices personnalisées
- `shared_preferences` - Stockage local

### APIs Utilisées
- **Aladhan API** - Horaires de prière précis
- **Google Maps** - Localisation des mosquées
- **Géocodage** - Conversion coordonnées/ville

## 📱 Installation

1. **Prérequis**
   ```bash
   flutter --version  # Flutter 3.8.1+
   ```

2. **Installation des dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancement de l'application**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

```
lib/
├── constants/          # Couleurs et thèmes
├── models/            # Modèles de données
├── pages/             # Pages de l'application
├── providers/         # Gestion d'état Provider
├── services/          # Services API et utilitaires
├── utils/             # Fonctions utilitaires
├── widgets/           # Widgets réutilisables
└── main.dart          # Point d'entrée
```

## 🌍 Fonctionnalités à Venir

- [ ] **Mode hors ligne** complet
- [ ] **Synchronisation cloud** des données
- [ ] **Communauté** et partage
- [ ] **Rappels personnalisés** avancés
- [ ] **Widget home screen** pour les horaires
- [ ] **Support multilingue** complet
- [ ] **Thèmes personnalisés** additionnels

## 📄 Licence

Cette application est développée pour la communauté musulmane avec ❤️.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer de nouvelles fonctionnalités
- Améliorer la documentation
- Traduire l'application

## 📞 Contact

Pour toute question ou suggestion :
- Email: support@athanmuslim.com
- Website: www.athanmuslim.com

---

**Athan Muslim** - Votre compagnon islamique complet 🕌

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
