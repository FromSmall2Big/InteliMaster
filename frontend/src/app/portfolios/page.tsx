import Header from '@/components/Header'
import Footer from '@/components/Footer'

export default function PortfoliosPage() {
  return (
    <main className="min-h-screen">
      <Header />
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-6">Portfolios</h1>
          <p className="text-lg text-gray-600 mb-12">A selection of our recent work.</p>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <div className="aspect-video bg-gray-100 rounded-lg shadow-sm flex items-center justify-center text-gray-500">Project 1</div>
            <div className="aspect-video bg-gray-100 rounded-lg shadow-sm flex items-center justify-center text-gray-500">Project 2</div>
            <div className="aspect-video bg-gray-100 rounded-lg shadow-sm flex items-center justify-center text-gray-500">Project 3</div>
          </div>
        </div>
      </section>
      <Footer />
    </main>
  )
}



