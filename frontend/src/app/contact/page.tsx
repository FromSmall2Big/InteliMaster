import Header from '@/components/Header'
import Contact from '@/app/contact/Contact'
import Footer from '@/components/Footer'

export default function ContactPage() {
  return (
    <main className="min-h-screen">
      <Header />
      <section className="pt-6">
        <Contact />
      </section>
      <Footer />
    </main>
  )
}



