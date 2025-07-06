import React, { useState, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import { ArrowLeft, Search, X } from 'lucide-react'
import { motion } from 'framer-motion'
import toast from 'react-hot-toast'
import ModernBookingCard from '../components/ModernBookingCard'
import { useBookings } from '../contexts/BookingContext'

const BookingListPage: React.FC = () => {
  const navigate = useNavigate()
  const { bookings, deleteBooking } = useBookings()
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedFilter, setSelectedFilter] = useState('all')

  const filteredBookings = useMemo(() => {
    let filtered = [...bookings]
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())

    // Apply search filter
    if (searchQuery) {
      filtered = filtered.filter(booking =>
        booking.petName.toLowerCase().includes(searchQuery.toLowerCase()) ||
        booking.ownerName.toLowerCase().includes(searchQuery.toLowerCase()) ||
        booking.petType.toLowerCase().includes(searchQuery.toLowerCase())
      )
    }

    // Apply category filter
    switch (selectedFilter) {
      case 'cat':
        filtered = filtered.filter(b => b.petType === 'cat')
        break
      case 'dog':
        filtered = filtered.filter(b => b.petType === 'dog')
        break
      case 'active':
        filtered = filtered.filter(b => {
          const checkIn = new Date(b.checkIn.getFullYear(), b.checkIn.getMonth(), b.checkIn.getDate())
          const checkOut = new Date(b.checkOut.getFullYear(), b.checkOut.getMonth(), b.checkOut.getDate())
          return checkIn <= today && checkOut > today
        })
        break
      case 'upcoming':
        filtered = filtered.filter(b => {
          const checkIn = new Date(b.checkIn.getFullYear(), b.checkIn.getMonth(), b.checkIn.getDate())
          return checkIn > today
        })
        break
    }

    // Sort by check-in date (most recent first)
    return filtered.sort((a, b) => b.checkIn.getTime() - a.checkIn.getTime())
  }, [bookings, searchQuery, selectedFilter])

  const handleDeleteBooking = (id: string, petName: string) => {
    if (window.confirm(`Are you sure you want to delete the booking for ${petName}?`)) {
      deleteBooking(id)
      toast.success(`Booking for ${petName} deleted`)
    }
  }

  const filters = [
    { key: 'all', label: 'All' },
    { key: 'active', label: 'Active' },
    { key: 'upcoming', label: 'Upcoming' },
    { key: 'cat', label: 'Cats' },
    { key: 'dog', label: 'Dogs' },
  ]

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-gradient-to-br from-primary-500 to-purple-600 text-white px-6 py-8">
        <button
          onClick={() => navigate('/')}
          className="flex items-center space-x-2 text-white/80 hover:text-white mb-6"
        >
          <ArrowLeft size={20} />
          <span>Back to Home</span>
        </button>
        <h1 className="text-3xl font-bold">All Bookings</h1>
        <p className="text-white/80 mt-2">Manage your pet boarding reservations</p>
      </div>

      <div className="px-6 py-8">
        {/* Search and Filter */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="mb-8"
        >
          {/* Search Bar */}
          <div className="relative mb-6">
            <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Search bookings..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-12 pr-12 py-4 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery('')}
                className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                <X size={20} />
              </button>
            )}
          </div>

          {/* Filter Chips */}
          <div className="flex flex-wrap gap-2">
            {filters.map((filter) => (
              <button
                key={filter.key}
                onClick={() => setSelectedFilter(filter.key)}
                className={`px-4 py-2 rounded-full text-sm font-medium transition-colors ${
                  selectedFilter === filter.key
                    ? 'bg-primary-500 text-white'
                    : 'bg-white text-gray-600 border border-gray-300 hover:border-gray-400'
                }`}
              >
                {filter.label}
              </button>
            ))}
          </div>
        </motion.div>

        {/* Bookings List */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
        >
          {filteredBookings.length === 0 ? (
            <EmptyState
              searchQuery={searchQuery}
              selectedFilter={selectedFilter}
            />
          ) : (
            <div className="space-y-4">
              {filteredBookings.map((booking) => (
                <ModernBookingCard
                  key={booking.id}
                  booking={booking}
                  onDelete={() => handleDeleteBooking(booking.id, booking.petName)}
                />
              ))}
            </div>
          )}
        </motion.div>
      </div>
    </div>
  )
}

interface EmptyStateProps {
  searchQuery: string
  selectedFilter: string
}

const EmptyState: React.FC<EmptyStateProps> = ({ searchQuery, selectedFilter }) => {
  let title: string
  let subtitle: string
  let icon: string

  if (searchQuery) {
    title = 'No results found'
    subtitle = 'Try adjusting your search or filters'
    icon = '🔍'
  } else if (selectedFilter !== 'all') {
    title = 'No bookings found'
    subtitle = 'No bookings match the selected filter'
    icon = '📋'
  } else {
    title = 'No bookings yet'
    subtitle = 'Add your first booking to get started'
    icon = '🐾'
  }

  return (
    <div className="bg-white border border-gray-200 rounded-2xl p-12 text-center">
      <div className="text-6xl mb-6">{icon}</div>
      <h3 className="text-xl font-semibold text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600">{subtitle}</p>
    </div>
  )
}

export default BookingListPage