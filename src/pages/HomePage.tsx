import React from 'react'
import { Link } from 'react-router-dom'
import { Plus, List, PawPrint } from 'lucide-react'
import { motion } from 'framer-motion'
import ModernHeader from '../components/ModernHeader'
import ModernCapacityCard from '../components/ModernCapacityCard'
import ModernBookingCard from '../components/ModernBookingCard'
import { useBookings } from '../contexts/BookingContext'

const HomePage: React.FC = () => {
  const { getCapacityCount, getTodayBookings, bookings } = useBookings()
  
  const today = new Date()
  const capacity = getCapacityCount(today)
  const todayBookings = getTodayBookings()
  const recentBookings = bookings.slice(-5).reverse()

  return (
    <div className="min-h-screen bg-gray-50">
      <ModernHeader />
      
      <div className="px-6 py-8 md:px-8">
        {/* Capacity Overview */}
        <motion.section 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="mb-8"
        >
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Capacity Overview</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <ModernCapacityCard
              title="Cat Rooms"
              current={capacity.cat}
              total={4}
              icon={PawPrint}
              gradient="bg-gradient-to-br from-pink-500 to-orange-400"
              accentColor="text-pink-500"
            />
            <ModernCapacityCard
              title="Dog Spaces"
              current={capacity.dog}
              total={2}
              icon={PawPrint}
              gradient="bg-gradient-to-br from-blue-500 to-cyan-400"
              accentColor="text-blue-500"
            />
          </div>
        </motion.section>

        {/* Quick Actions */}
        <motion.section 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
          className="mb-8"
        >
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Quick Actions</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Link to="/booking" className="group">
              <div className="bg-white border border-gray-200 rounded-2xl p-6 hover:shadow-md transition-shadow">
                <div className="bg-primary-100 p-3 rounded-xl w-fit mb-4 group-hover:bg-primary-200 transition-colors">
                  <Plus className="text-primary-600" size={24} />
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">New Booking</h3>
                <p className="text-gray-600">Add a new pet booking</p>
              </div>
            </Link>
            <Link to="/bookings" className="group">
              <div className="bg-white border border-gray-200 rounded-2xl p-6 hover:shadow-md transition-shadow">
                <div className="bg-cyan-100 p-3 rounded-xl w-fit mb-4 group-hover:bg-cyan-200 transition-colors">
                  <List className="text-cyan-600" size={24} />
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">All Bookings</h3>
                <p className="text-gray-600">View all bookings</p>
              </div>
            </Link>
          </div>
        </motion.section>

        {/* Today's Bookings */}
        <motion.section 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.2 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-bold text-gray-900">Today's Bookings</h2>
            <span className="bg-primary-100 text-primary-600 px-3 py-1 rounded-full text-sm font-semibold">
              {todayBookings.length}
            </span>
          </div>
          {todayBookings.length === 0 ? (
            <EmptyState
              icon="📅"
              title="No bookings today"
              subtitle="All pets are checked out for today"
            />
          ) : (
            <div className="space-y-4">
              {todayBookings.map((booking) => (
                <ModernBookingCard key={booking.id} booking={booking} />
              ))}
            </div>
          )}
        </motion.section>

        {/* Recent Bookings */}
        <motion.section 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.3 }}
        >
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-bold text-gray-900">Recent Bookings</h2>
            <Link to="/bookings" className="text-primary-600 hover:text-primary-700 font-medium">
              View All
            </Link>
          </div>
          {recentBookings.length === 0 ? (
            <EmptyState
              icon="🐾"
              title="No bookings yet"
              subtitle="Add your first booking to get started"
            />
          ) : (
            <div className="space-y-4">
              {recentBookings.map((booking) => (
                <ModernBookingCard key={booking.id} booking={booking} />
              ))}
            </div>
          )}
        </motion.section>
      </div>
    </div>
  )
}

interface EmptyStateProps {
  icon: string
  title: string
  subtitle: string
}

const EmptyState: React.FC<EmptyStateProps> = ({ icon, title, subtitle }) => (
  <div className="bg-gray-100 border border-gray-200 rounded-2xl p-8 text-center">
    <div className="text-4xl mb-4">{icon}</div>
    <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
    <p className="text-gray-600">{subtitle}</p>
  </div>
)

export default HomePage