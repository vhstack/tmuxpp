<p align="right">
  <a href="README.md"><img src="https://flagcdn.com/16x12/de.png" alt="Deutsch" title="Zur deutschen Version wechseln" /></a>  
  <a href="README.en.md"><img src="https://flagcdn.com/16x12/gb.png" alt="English" title="Switch to English" /></a>  
  <a href="README.ru.md"><img src="https://flagcdn.com/16x12/ru.png" alt="Русский" title="Переключиться на русскую версию" /></a>
</p>

# Конфигурация Tmux

Эта конфигурация Tmux оптимизирует работу за счёт полезных сочетаний клавиш, поддержки True Color и различных плагинов.  
Скрипт-пример `sample_run.sh` автоматически настраивает и запускает сессию с несколькими окнами.

![Скриншот](assets/screenshot.png)

## 📥 Установка

### 1. Установите Tmux
Если Tmux ещё не установлен:
```sh
sudo apt install tmux   # Debian/Ubuntu
brew install tmux       # macOS
```
Дополнительную информацию можно найти в [**Tmux Wiki**](https://github.com/tmux/tmux/wiki).

### 2. Установите переменную TERM
Добавьте в файл `~/.bashrc`:
```sh
export TERM=xterm-256color
```

### 3. Клонируйте репозиторий и примените конфигурацию
```sh
git clone --depth 1 https://github.com/vhstack/tmuxpp.git ~/.tmux
rm -rf ~/.tmux/.git ~/.tmux/assets ~/.tmux/README*.md
ln -s ~/.tmux/tmux.conf ~/.tmux.conf
```

### 4. Установите TPM (Tmux Plugin Manager)
```sh
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf ~/.tmux/plugins/tpm/.git
```
Подробнее см. в [**TPM-Repository**](https://github.com/tmux-plugins/tpm).

### 5. Установите плагины
Запустите Tmux и нажмите:
```
Prefix + I  # Устанавливает плагины
```

## ⌨ Сочетания клавиш

- **Клавиша Prefix**: `Ctrl + A` (вместо `Ctrl + B`)
- **Управление окнами:**
  - `Prefix + +` → Создать новую сессию
  - `Prefix + c` → Создать окно
  - `Prefix + ,` → Переименовать окно
  - `Prefix + x` → Закрыть окно
  - `Prefix + $` → Переименовать сессию
  - `Prefix + |` → Вертикальное разделение
  - `Prefix + -` → Горизонтальное разделение
  - `Prefix + N` → Отсоединить панель
- **Навигация:**
  - `Prefix + ←, →, ↑, ↓` → Переключаться между панелями
  - `Alt + →` / `Alt + ←` → Переключаться между окнами
  - `Ctrl + Alt + →` / `Ctrl + Alt + ←` → Перемещать окно
- **Изменение размера окон:**
  - `Prefix + j/k/h/l` → Изменить размер окна
  - `Prefix + m` → Максимизировать/Восстановить
- **Перезагрузить конфигурацию:**
  - `Prefix + r`

## 📦 Плагины
Управляются через TPM:
- `christoomey/vim-tmux-navigator` → Навигация, как в Vim
- `tmux-plugins/tmux-sessionist` → Управление сессиями

## 🎨 Цвет & Тема
- Включена поддержка True Color
- Доступные темы (через `@theme` в `tmux.conf`): `vhstack`, `vhstack_lite`, `catppuccin`
- Тема `vhstack` активирована по умолчанию

---
Теперь вы можете эффективно использовать вашу Tmux-сессию! 🚀
