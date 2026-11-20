/** @type {import('tailwindcss').Config} */
const c = (name) => `rgb(var(--${name}) / <alpha-value>)`

export default {
  darkMode: 'class',
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      fontFamily: { sans: ['Outfit', 'system-ui', 'sans-serif'] },
      colors: {
        page: c('page'),
        card: c('card'),
        sidebar: c('sidebar'),
        line: c('line'),
        ink: c('ink'),
        muted: c('muted'),
        primary: c('primary'),
        'primary-fg': c('primary-fg'),
        danger: c('danger'),
        success: c('success'),
        warning: c('warning'),
        accent: c('accent'),
      },
      boxShadow: { card: '0 1px 2px rgb(0 0 0 / 0.06), 0 1px 3px rgb(0 0 0 / 0.04)' },
    },
  },
  plugins: [],
}
