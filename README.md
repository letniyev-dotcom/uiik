# letnievpn iOS

Перенос letnievpn с Android на iOS. Сейчас — дизайн-шаблон первой версии:
главный экран (кнопка включения, умное подключение, список подписок с серверами),
светлая/тёмная темы с розовым акцентом из прототипа. Все данные моковые,
сетевой слой (загрузка подписок, пинг, VPN-туннель) подключается следующим шагом.

## Сборка локально

```bash
brew install xcodegen
xcodegen
open letnievpn.xcodeproj
```

## Сборка IPA через GitHub Actions

Пуш в `main` или запуск workflow вручную (Actions → build-ios → Run workflow).
Артефакт `letnievpn-unsigned-ipa` — неподписанный IPA, подписывается самостоятельно
(AltStore/Sideloadly/Xcode или свой сертификат).
