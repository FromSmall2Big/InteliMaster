'use client'

import { useState, useEffect } from 'react'

interface Service {
  id: number
  title: string
  description: string
  image: string
  icon: string
  technologies: string[]
}

export default function ServicesPreview() {
  const [services, setServices] = useState<Service[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchServices = async () => {
      try {
        const response = await fetch('/images/services/services.json')
        if (!response.ok) {
          throw new Error('Failed to fetch services')
        }
        const data = await response.json()
        setServices(data.services)
      } catch (error) {
        console.error('Error fetching services:', error)
        setServices([]) // Empty array if fetch fails
      } finally {
        setLoading(false)
      }
    }

    fetchServices()
  }, [])

  if (loading) {
    return (
      <section id="services" className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Services</h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              We offer comprehensive software development services to help your business thrive in the digital world.
            </p>
          </div>
          <div className="flex justify-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
        </div>
      </section>
    )
  }

  if (services.length === 0) {
    return (
      <section id="services" className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Services</h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              We offer comprehensive software development services to help your business thrive in the digital world.
            </p>
          </div>
          <div className="text-center">
            <p className="text-gray-500">No services available at the moment.</p>
          </div>
        </div>
      </section>
    )
  }

  return (
    <section id="services" className="py-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Services</h2>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            We offer comprehensive software development services to help your business thrive in the digital world.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {services.map((service) => (
            <div key={service.id} className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow overflow-hidden group">
              <div className="relative h-48 overflow-hidden bg-gray-200">
                <img
                  src={`/images/services/${service.image}`}
                  alt={service.title}
                  className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                  onError={(e) => {
                    e.currentTarget.style.display = 'none'
                    const nextElement = e.currentTarget.nextElementSibling as HTMLElement
                    if (nextElement) {
                      nextElement.style.display = 'flex'
                    }
                  }}
                />
                <div className="absolute inset-0 bg-gray-200 flex items-center justify-center text-gray-500 text-6xl" style={{display: 'none'}}>
                  {service.icon}
                </div>
                <div className="absolute top-4 left-4 bg-white bg-opacity-90 rounded-full p-2">
                  <span className="text-2xl">{service.icon}</span>
                </div>
              </div>
              <div className="p-6">
                <h3 className="text-xl font-semibold text-gray-900 mb-3">{service.title}</h3>
                <p className="text-gray-600 mb-4">{service.description}</p>
                <div className="flex flex-wrap gap-2">
                  {service.technologies.map((tech, index) => (
                    <span
                      key={index}
                      className="text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded-md"
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
  )
}