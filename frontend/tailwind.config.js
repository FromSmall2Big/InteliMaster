/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          900: '#1e3a8a',
        },
      },
      animation: {
        'diagonal-sweep': 'diagonal-sweep 4s ease-in-out infinite',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'bounce-slow': 'bounce 2s infinite',
        'flash': 'flash 3s ease-in-out infinite',
      },
      keyframes: {
        'diagonal-sweep': {
          '0%': { 
            transform: 'translate(-100%, -100%)',
            opacity: '0'
          },
          '10%': { 
            opacity: '0.6'
          },
          '90%': { 
            opacity: '0.6'
          },
          '100%': { 
            transform: 'translate(100%, 100%)',
            opacity: '0'
          },
        },
        flash: {
          '0%, 50%, 100%': { opacity: '1' },
          '25%, 75%': { opacity: '0.1' },
        },
      },
    },
  },
  plugins: [],
}
