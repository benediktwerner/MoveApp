# Move 2020 App

App für die [Move 2020](https://www.move2020.org/).

## Design

- Firebase Cloud Store als Backend
    - Automatisches updaten und synchronisieren von Daten
    - Offlinebenutzung
- Webinterface für Admins
    - Veranstaltungen
    - Sprecher/Musiker
    - Benachrichtigungen
- Seiten
    - Startseite: Was ist die Move 2020
        - Alternativ: Übersicht als Startseite und "Was ist die Move" als andere Seite
    - Programm
        - Verlinkung zu Sprechern/Musikern?
    - Gebetsbuch
    - Sprecher + Musiker (Informationen zu den Rednern, Vorträgen)
    - Lageplan
        - Karte mit Veranstaltungsorten (am Besten statisch für Offlinenutzung)
        - Navigation mit Google Maps wenn online
    - News/Benachrichtigungen
    - Spende (Verknüpfung via link mit Spendenkonto, PayPal, Sofortüberweisung)
    - Social Media Buttons (YouTube, Facebook, Instagram, WhatsApp??)
    - Suche: App nach Stichworten durchsuchen
        - Programm
        - Gebetsbuch?
        - Sprecher/Musiker
        - Lageplan: Veranstaltungsorte
        - News/Benachrichtigungen
        - Spenden
        - Social Media

## TODO for iOS
- Drag `GoogleService-info.plist` into Runner directory in Xcode (check `Create groups`)
- Register push notifications on APNs: https://firebase.google.com/docs/cloud-messaging/ios/certs
