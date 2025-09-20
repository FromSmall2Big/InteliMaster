'use client'

import { useState } from 'react'
import { useAuth } from '@/lib/useAuth'
import Link from 'next/link'
import Image from 'next/image'

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const { user, logout, isAuthenticated } = useAuth()

  return (
    <header className="bg-white shadow-md sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          <div className="flex items-center">
            <Link href="/" className="flex items-center">
              <Image
                src="/images/logo.png"
                alt="InteliMaster Logo"
                width={120}
                height={40}
                className="h-20 w-auto m-2"
                priority
              />
              <h1 className="text-3xl font-extrabold text-blue-600 m-2 tracking-tight relative overflow-hidden">
                <span className="relative z-10">InteliMaster</span>
                <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white to-transparent opacity-50 animate-diagonal-sweep"></div>
              </h1>
            </Link>
          </div>
          
          {/* Desktop Navigation */}
          <nav className="hidden md:flex space-x-8 items-center">
            <Link href="/services" className="text-gray-700 hover:text-primary-600 transition-colors">
              Services
            </Link>
            <Link href="/portfolios" className="text-gray-700 hover:text-primary-600 transition-colors">
              Portfolios
            </Link>
            <Link href="/about" className="text-gray-700 hover:text-primary-600 transition-colors">
              About
            </Link>
            <Link href="/contact" className="text-gray-700 hover:text-primary-600 transition-colors">
              Contact
            </Link>
            
            {/* Authentication buttons */}
            {isAuthenticated ? (
              <div className="flex items-center space-x-4">
                <span className="text-sm text-gray-600">
                  Welcome, {user?.full_name}
                </span>
                <button
                  onClick={logout}
                  className="bg-red-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-red-700 transition-colors"
                >
                  Logout
                </button>
              </div>
            ) : (
              <div className="flex items-center space-x-4">
                <Link
                  href="/signin"
                  className="text-gray-700 hover:text-primary-600 transition-colors"
                >
                  Sign In
                </Link>
                <Link
                  href="/signup"
                  className="bg-primary-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-primary-700 transition-colors"
                >
                  Sign Up
                </Link>
              </div>
            )}
          </nav>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="text-gray-700 hover:text-primary-600 focus:outline-none"
            >
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
          </div>
        </div>

        {/* Mobile Navigation */}
        {isMenuOpen && (
          <div className="md:hidden">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3 bg-white border-t">
              <Link href="/" className="block px-3 py-2 text-gray-700 hover:text-primary-600">
                Home
              </Link>
              <Link href="/services" className="block px-3 py-2 text-gray-700 hover:text-primary-600">
                Services
              </Link>
              <Link href="/about" className="block px-3 py-2 text-gray-700 hover:text-primary-600">
                About
              </Link>
              <Link href="/contact" className="block px-3 py-2 text-gray-700 hover:text-primary-600">
                Contact
              </Link>
              <Link href="/portfolios" className="block px-3 py-2 text-gray-700 hover:text-primary-600">
                Portfolios
              </Link>
              
              {/* Mobile Authentication */}
              {isAuthenticated ? (
                <div className="pt-2 border-t">
                  <div className="px-3 py-2 text-sm text-gray-600">
                    Welcome, {user?.full_name}
                  </div>
                  <button
                    onClick={logout}
                    className="block w-full text-left px-3 py-2 text-red-600 hover:text-red-700"
                  >
                    Logout
                  </button>
                </div>
              ) : (
                <div className="pt-2 border-t space-y-1">
                  <Link
                    href="/signin"
                    className="block px-3 py-2 text-gray-700 hover:text-primary-600"
                  >
                    Sign In
                  </Link>
                  <Link
                    href="/signup"
                    className="block px-3 py-2 bg-primary-600 text-white rounded-md hover:bg-primary-700"
                  >
                    Sign Up
                  </Link>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </header>
  )
}
