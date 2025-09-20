import Image from 'next/image'

export default function AboutPreview() {
  return (
    <section id="about" className="py-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-6">About InteliMasters L.L.C.</h2>
            <p className="text-lg text-gray-600 mb-6">
              We are a passionate team of software developers, designers, and engineers dedicated to creating exceptional
              digital solutions.
            </p>
            <p className="text-lg text-gray-600 mb-8">
              Our mission is to help companies leverage technology to achieve their goals. We pride ourselves on
              delivering high-quality, scalable solutions that make a real difference.
            </p>
          </div>
          <div className="relative h-96 rounded-lg overflow-hidden shadow-md">
            <Image
              src="/images/team_discuss.jpg"
              alt="InteliMaster team collaborating in the office"
              fill
              sizes="(max-width: 1024px) 100vw, 50vw"
              className="object-cover"
              priority
            />
          </div>
        </div>
      </div>
    </section>
  )
}


