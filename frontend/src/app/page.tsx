'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/useAuth';
import Header from '@/components/Header';
import Hero from '@/components/Hero';
import ServicesPreview from '@/app/services/ServicesPreview';
import AboutPreview from '@/app/about/AboutPreview';
import ContactPreview from '@/app/contact/ContactPreview';
import Footer from '@/components/Footer';

export default function Home() {
  const { isAuthenticated, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && isAuthenticated) {
      //router.push('/');
    }
  }, [isAuthenticated, loading, router]);

  if (loading) {
    return (
      <main className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-indigo-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading...</p>
        </div>
      </main>
    );
  }

  if (isAuthenticated) {
    //return null; // Will redirect to dashboard
  }

  return (
    <main className="min-h-screen">
      <Header />
      <Hero />
      <ServicesPreview />
      <AboutPreview />
      <ContactPreview />
      <Footer />
    </main>
  );
}
