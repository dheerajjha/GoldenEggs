/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#1A73E8',
        secondary: '#34A853',
        danger: '#EA4335',
        warning: '#FBBC04',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
} 