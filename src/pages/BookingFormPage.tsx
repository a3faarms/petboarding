import React from 'react'
import { useNavigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { ArrowLeft, PawPrint } from 'lucide-react'
import { motion } from 'framer-motion'
import toast from 'react-hot-toast'
import { BookingFormData } from '../types/booking'
import { useBookings } from '../contexts/BookingContext'
import VoiceBooking  from '../components/VoiceBooking';

const BookingFormPage: React.FC = () => {
  const navigate = useNavigate()
  const { addBooking } = useBookings()
  
  const {
    register,
    handleSubmit,
    watch,
    formState: { errors, isSubmitting },
  } = useForm<BookingFormData>()

  const petType = watch('petType')

  const onSubmit = async (data: BookingFormData) => {
    try {
      // Validate dates
      const checkIn = new Date(data.checkIn)
      const checkOut = new Date(data.checkOut)
      
      if (checkOut <= checkIn) {
        toast.error('Check-out date must be after check-in date')
        return
      }

      addBooking({
        ...data,
        checkIn,
        checkOut,
      })

      toast.success('Booking created successfully!')
      navigate('/')
    } catch (error) {
      toast.error('Failed to create booking. Please try again.')
    }
  }

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
        <h1 className="text-3xl font-bold">New Booking</h1>
        <p className="text-white/80 mt-2">Add a new pet boarding reservation</p>
      </div>

      <div className="px-6 py-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="max-w-2xl mx-auto"
        >
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
            {/* Pet Information */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-4">Pet Information</h2>
              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Pet Name
                  </label>
                  <input
                    type="text"
                    {...register('petName', { required: 'Pet name is required' })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Enter pet name"
                  />
                  {errors.petName && (
                    <p className="mt-1 text-sm text-red-600">{errors.petName.message}</p>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-4">
                    Pet Type
                  </label>
                  <div className="grid grid-cols-2 gap-4">
                    <PetTypeCard
                      type="cat"
                      label="Cat"
                      isSelected={petType === 'cat'}
                      register={register}
                    />
                    <PetTypeCard
                      type="dog"
                      label="Dog"
                      isSelected={petType === 'dog'}
                      register={register}
                    />
                  </div>
                  {errors.petType && (
                    <p className="mt-2 text-sm text-red-600">{errors.petType.message}</p>
                  )}
                </div>
              </div>
            </section>

            {/* Owner Information */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-4">Owner Information</h2>
              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Owner Name
                  </label>
                  <input
                    type="text"
                    {...register('ownerName', { required: 'Owner name is required' })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Enter owner name"
                  />
                  {errors.ownerName && (
                    <p className="mt-1 text-sm text-red-600">{errors.ownerName.message}</p>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Phone Number
                  </label>
                  <input
                    type="tel"
                    {...register('ownerPhone', { required: 'Phone number is required' })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Enter phone number"
                  />
                  {errors.ownerPhone && (
                    <p className="mt-1 text-sm text-red-600">{errors.ownerPhone.message}</p>
                  )}
                </div>
              </div>
            </section>

            {/* Booking Details */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-4">Booking Details</h2>
              <div className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Check-in Date
                    </label>
                    <input
                      type="date"
                      {...register('checkIn', { required: 'Check-in date is required' })}
                      min={new Date().toISOString().split('T')[0]}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                    {errors.checkIn && (
                      <p className="mt-1 text-sm text-red-600">{errors.checkIn.message}</p>
                    )}
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Check-out Date
                    </label>
                    <input
                      type="date"
                      {...register('checkOut', { required: 'Check-out date is required' })}
                      min={new Date().toISOString().split('T')[0]}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                    {errors.checkOut && (
                      <p className="mt-1 text-sm text-red-600">{errors.checkOut.message}</p>
                    )}
                  </div>
                </div>
                <div style={{ padding: '2rem', background: '#eee', border: '2px solid red' }}>
                  <h2>Voice Facilitator</h2>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Special Notes (Optional)
                  </label>
                  <textarea
                    {...register('notes')}
                    rows={3}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Any special instructions or notes..."
                  />
                </div>
              </div>
            </section>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full bg-primary-500 text-white py-4 px-6 rounded-xl font-semibold hover:bg-primary-600 focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {isSubmitting ? 'Creating Booking...' : 'Create Booking'}
            </button>
          </form>
          {/* 👇 Add VoiceBooking right here */}
        <div className="mt-12">
          <VoiceBooking />
        </div>
        </motion.div>
      </div>
    </div>
  )
}

interface PetTypeCardProps {
  type: 'cat' | 'dog'
  label: string
  isSelected: boolean
  register: any
}

const PetTypeCard: React.FC<PetTypeCardProps> = ({ type, label, isSelected, register }) => {
  const colorClasses = type === 'cat' 
    ? 'border-cat-primary bg-cat-secondary text-cat-primary' 
    : 'border-dog-primary bg-dog-secondary text-dog-primary'

  return (
    <label className="cursor-pointer">
      <input
        type="radio"
        value={type}
        {...register('petType', { required: 'Please select a pet type' })}
        className="sr-only"
      />
      <div className={`
        border-2 rounded-xl p-6 text-center transition-all
        ${isSelected 
          ? colorClasses
          : 'border-gray-200 bg-white text-gray-600 hover:border-gray-300'
        }
      `}>
        <div className={`
          w-12 h-12 mx-auto mb-3 rounded-xl flex items-center justify-center
          ${isSelected 
            ? (type === 'cat' ? 'bg-cat-primary/20' : 'bg-dog-primary/20')
            : 'bg-gray-100'
          }
        `}>
          <PawPrint size={24} />
        </div>
        <span className="font-semibold">{label}</span>
      </div>
    </label>
  )
}

<<<<<<< HEAD
export default BookingFormPage
=======
export default BookingFormPage
>>>>>>> 27e195ac4a2da4210e713e4bffbcaec9def98bd6
