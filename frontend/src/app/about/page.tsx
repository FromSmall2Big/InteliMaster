import Header from '@/components/Header'
import About from '@/app/about/About'
import Contact from "@/app/contact/ContactPreview"
import Footer from '@/components/Footer'

export default function AboutPage() {
  return (
    <main className="min-h-screen">
      <Header />
      <section className="pt-6">
        <About />
      </section>
      <section className="pt-6">
        <Contact />
      </section>
      <Footer />
    </main>
  )
}



