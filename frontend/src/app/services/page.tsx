import Header from '@/components/Header'
import Services from '@/app/services/Services'
import Footer from '@/components/Footer'

export default function ServicesPage() {
  return (
    <main className="min-h-screen">
      <Header />
      <section className="pt-6">
        <Services />
      </section>
      <Footer />
    </main>
  )
}



