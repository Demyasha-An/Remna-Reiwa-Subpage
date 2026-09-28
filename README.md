<div align="center">

![Demo](assets/demo.gif)

# 🌊 Remna Reiwa Subpage

**Страница подписки для панели [RemnaWave](https://docs.rw) с WebGL2 warp-шейдером**

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![RemnaWave](https://img.shields.io/badge/RemnaWave-Panel-purple.svg)](https://docs.rw)

</div>

---

## ✨ Возможности

<table>
<tr>
<td width="50%">

### 🎨 Визуал
- **WebGL2 Warp-шейдер** — динамический анимированный фон
- **11 встроенных тем** — Purple … Blush + [Open Color](https://github.com/yeun/open-color) (Red, Grape, Teal, Yellow)
- **Адаптивный дизайн** — работает на мобильных и десктопе
- **Тёмная и светлая вариация** — для каждой палитры; по умолчанию **как на устройстве** (`prefers-color-scheme`), в настройках можно зафиксировать светлую/тёмную

</td>
<td width="50%">

### 📊 Функционал
- **Информация о подписке** — статус, срок, трафик, имя пользователя
- **QR-код** — быстрая ссылка на подписку
- **Гайды по приложениям** — инструкции по настройке для всех платформ
- **Мультиязычность** — поддержка i18n

</td>
</tr>
</table>

---

## 🎨 Темы

Скриншоты всех 11 тем (тёмный/светлый режим) — в **[THEMES.md](THEMES.md)**.

---

## 🚀 Быстрая установка

> **Важно:** Все команды выполняются в директории `/opt/remnawave/subscription/` (или там, где находится ваш `docker-compose.yml`)

### Одна строка (интерактивно)

```bash
cd /opt/remnawave/subscription/
curl -L -s -O https://raw.githubusercontent.com/d3myasha/Remna-Reiwa-Subpage/main/setup.sh && bash setup.sh
```

### Неинтерактивно (с выбором темы)

```bash
bash setup.sh -t 3              # Тема Cyberpunk (тёмная)
bash setup.sh -t 1 -m light     # Purple, светлая вариация
bash setup.sh -t 2 -l ru        # Тема Monochrome + русский язык
```

**Темы:** `1`–`11` (см. [THEMES.md](THEMES.md)). Флаг `-m dark|light` при установке задаёт только превью в интерактивном режиме; в `index.html` всегда прописываются **обе** палитры, страница сама переключается по системе.

---

## 🔄 Обновление

```bash
cd /opt/remnawave/subscription/
rm -rf setup.sh index.html
curl -L -s -O https://raw.githubusercontent.com/d3myasha/Remna-Reiwa-Subpage/main/setup.sh && bash setup.sh
```

---

## 📦 Ручная установка

<details>
<summary><b>Развернуть инструкции по ручной установке</b></summary>

### 1. Скачай `index.html`

```bash
# Через curl
curl -L -o /opt/remnawave/subscription/index.html \
  https://raw.githubusercontent.com/d3myasha/Remna-Reiwa-Subpage/main/index.html

# Или через wget
wget -O /opt/remnawave/subscription/index.html \
  https://raw.githubusercontent.com/d3myasha/Remna-Reiwa-Subpage/main/index.html
```

### 2. Добавь volume mount в `docker-compose.yml`

```yaml
services:
  remnawave-subscription-page:
    volumes:
      - ./index.html:/opt/app/frontend/index.html
```

### 3. Перезапусти контейнер

```bash
docker compose restart remnawave-subscription-page
```

**Структура директории:**
```
/opt/remnawave/subscription/
├── docker-compose.yml
├── .env
└── index.html
```

</details>

---

## ⚙️ Настройка Warp-эффекта

<details>
<summary><b>Расширенные настройки: параметры warp-шейдера</b></summary>

Редактируй вызов `initWarpEffect()` в `index.html`:

| Параметр | По умолчанию | Описание |
|---|---|---|
| `speed` | `0.8` | Скорость анимации |
| `proportion` | `0.55` | Пропорция смешивания цветов |
| `distortion` | `0.12` | Сила искажения шума |
| `swirl` | `1.0` | Интенсивность завихрений |
| `swirlIterations` | `13` | Количество итераций завихрения |
| `shape` | `1` | Тип узора (0=сетка, 1=полосы, 2=край) |
| `softness` | `0.8` | Мягкость цветовых переходов |
| `colors` | `[[R,G,B], ...]` | Массив цветов палитры |

</details>

---

## 📋 Требования

- **Панель RemnaWave 3.0.0+** — рекомендуемая версия для Subscription Page v8.0.0
- **Subscription Page v8.0.0+** — страница работает как EJS-шаблон: `<%- panelData %>` и `<%= metaTitle %>`
- **Docker** — для развёртывания в контейнере
- **Реверс-прокси с HTTPS** — обязателен, см. раздел «🌐 Реверс-прокси» ниже
- **Сжатие на реверс-прокси** — с v8.0.0 само приложение ответы не сжимает
- **Современный браузер** — требуется поддержка WebGL2

---

## 🌐 Реверс-прокси

Начиная с **Subscription Page v8.0.0** приложение **больше не сжимает тела ответов**: компрессия полностью передана на реверс-прокси. Там же появилась проверка `proxyCheckMiddleware` — без корректных заголовков соединение просто разрывается, а не возвращает ошибку.

### Caddy

Caddy — самый простой вариант: **сжатие работает из коробки, настраивать ничего не нужно**. Директива `encode` входит в стандартный порядок обработки и стоит *выше* `reverse_proxy`, поэтому она оборачивает и сжимает проксированные ответы автоматически. По умолчанию включены `zstd` и `gzip` (порог — 512 байт).

Достаточно базового конфига:

```caddyfile
sub.example.com {
    reverse_proxy 127.0.0.1:3010
}
```

> [!WARNING]
> Не отключай `encode` — ни глобальным параметром `order`, ни удалением директивы. Иначе страница (~145 КБ) будет отдаваться без сжатия.

**Нюансы, о которых стоит знать:**

- Сжимаются `text/*`, `application/json` и подобное. Картинки (`image/*`) не сжимаются — они уже сжаты, Caddy пропускает их корректно.
- В `.env` оставь `TRUST_PROXY=1` — это один доверенный хоп (Caddy). Нужно, чтобы определять реальный IP клиента и защититься от подмены через `X-Forwarded-For`.
- Caddy сам выставляет `X-Forwarded-For` и `X-Forwarded-Proto: https`, поэтому проверка прокси проходит. **Проксировать напрямую на `3010` по HTTP нельзя** — соединение разорвётся.

**Проверить, что сжатие работает:**

```bash
curl -s -D - -o /dev/null -H 'Accept-Encoding: gzip, zstd' https://sub.example.com/<short-uuid>
```

В ответе должен быть заголовок `content-encoding: zstd` (или `gzip`).

### Nginx / Traefik

Если используешь другой прокси, сжатие нужно включить явно. Для nginx:

```nginx
gzip on;
gzip_vary on;
gzip_min_length 512;
gzip_types text/plain text/css application/json application/javascript text/html;
```

Traefik сжимает ответы по умолчанию — достаточно middleware `compress` (в v2/v3 он включён в цепочку по умолчанию).

---

## 📄 Лицензия

MIT © 2026

---

<div align="center">

**Сделано с** ❤️ **для RemnaWave**

[Сообщить о баге](https://github.com/d3myasha/Remna-Reiwa-Subpage/issues) • [Предложить фичу](https://github.com/d3myasha/Remna-Reiwa-Subpage/issues)

</div>
