import React from 'react'
import { PawPrint } from 'lucide-react'

const ModernHeader: React.FC = () => {
  return (
    <div className="bg-gradient-to-br from-primary-500 to-purple-600 text-white">
      <div className="px-6 py-16 md:px-8">
        <div className="flex items-center space-x-4">
          <div className="bg-white/20 p-3 rounded-2xl">
            <PawPrint size={32} />
          </div>
          <div>
            <h1 className="text-3xl md:text-4xl font-bold">Pet Boarding</h1>
            <p className="text-xl font-medium text-white/90">Management System</p>
          </div>
        </div>
        <p className="mt-4 text-lg text-white/80 max-w-2xl">
          Streamline your pet boarding operations with our comprehensive management platform
        </p>
      </div>
    </div>
  )
}

export default ModernHeader