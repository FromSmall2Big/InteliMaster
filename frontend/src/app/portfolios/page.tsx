import Header from '@/components/Header'
import Footer from '@/components/Footer'
import Image from 'next/image'

interface Portfolio {
  id: number
  title: string
  description: string
  image: string
  technologies: string[]
  category: string
}

interface PortfoliosData {
  portfolios: Portfolio[]
}

async function getPortfolios(): Promise<Portfolio[]> {
  const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000'
  const response = await fetch(`${baseUrl}/images/portfolios/portfolios.json`, {
    cache: 'no-store'
  })
  
  if (!response.ok) {
    throw new Error(`Failed to fetch portfolios: ${response.status} ${response.statusText}`)
  }
  
  const data: PortfoliosData = await response.json()
  return data.portfolios
}

export default async function PortfoliosPage() {
  const portfolios = await getPortfolios()
  return (
    <main className="min-h-screen">
      <Header />
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-6">Portfolios</h1>
          <p className="text-lg text-gray-600 mb-12">A selection of our recent work.</p>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {portfolios.map((portfolio) => (
              <div key={portfolio.id} className="group cursor-pointer">
                <div className="aspect-video relative overflow-hidden rounded-lg shadow-sm">
                  <Image
                    src={`/images/portfolios/${portfolio.image}`}
                    alt={portfolio.title}
                    fill
                    className="object-cover transition-transform duration-300 group-hover:scale-105"
                  />
                </div>
                <div className="mt-4">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm font-medium text-blue-600 bg-blue-50 px-2 py-1 rounded-full">
                      {portfolio.category}
                    </span>
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 group-hover:text-blue-600 transition-colors">
                    {portfolio.title}
                  </h3>
                  <p className="mt-2 text-gray-600 text-sm leading-relaxed">
                    {portfolio.description}
                  </p>
                  <div className="mt-3 flex flex-wrap gap-1">
                    {portfolio.technologies.map((tech, index) => (
                      <span
                        key={index}
                        className="text-xs bg-gray-100 text-gray-700 px-2 py-1 rounded-md"
                      >
                        {tech}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
      <Footer />
    </main>
  )
}



