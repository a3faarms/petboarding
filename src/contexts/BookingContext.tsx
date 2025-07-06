import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { Booking, BookingFormData } from '../types/booking'

interface BookingContextType {
  bookings: Booking[]
  addBooking: (bookingData: BookingFormData) => void
  deleteBooking: (id: string) => void
  getCapacityCount: (date: Date) => { cat: number; dog: number }
  getTodayBookings: () => Booking[]
}

const BookingContext = createContext<BookingContextType | undefined>(undefined)

export const useBookings = () => {
  const context = useContext(BookingContext)
  if (context === undefined) {
    throw new Error('useBookings must be used within a BookingProvider')
  }
  return context
}

interface BookingProviderProps {
  children: ReactNode
}

export const BookingProvider: React.FC<BookingProviderProps> = ({ children }) => {
  const [bookings, setBookings] = useState<Booking[]>([])

  // Load bookings from localStorage on mount
  useEffect(() => {
    const savedBookings = localStorage.getItem('petBoardingBookings')
    if (savedBookings) {
      try {
        const parsed = JSON.parse(savedBookings)
        const bookingsWithDates = parsed.map((booking: any) => ({
          ...booking,
          checkIn: new Date(booking.checkIn),
          checkOut: new Date(booking.checkOut),
          createdAt: new Date(booking.createdAt),
        }))
        setBookings(bookingsWithDates)
      } catch (error) {
        console.error('Error loading bookings from localStorage:', error)
      }
    }
  }, [])

  // Save bookings to localStorage whenever bookings change
  useEffect(() => {
    localStorage.setItem('petBoardingBookings', JSON.stringify(bookings))
  }, [bookings])

  const addBooking = (bookingData: BookingFormData) => {
    const newBooking: Booking = {
      id: Date.now().toString(),
      ...bookingData,
      createdAt: new Date(),
    }
    setBookings(prev => [...prev, newBooking])
  }

  const deleteBooking = (id: string) => {
    setBookings(prev => prev.filter(booking => booking.id !== id))
  }

  const getCapacityCount = (date: Date) => {
    const targetDate = new Date(date.getFullYear(), date.getMonth(), date.getDate())
    
    let catCount = 0
    let dogCount = 0

    bookings.forEach(booking => {
      const checkIn = new Date(booking.checkIn.getFullYear(), booking.checkIn.getMonth(), booking.checkIn.getDate())
      const checkOut = new Date(booking.checkOut.getFullYear(), booking.checkOut.getMonth(), booking.checkOut.getDate())

      if (checkIn <= targetDate && checkOut > targetDate) {
        if (booking.petType === 'cat') catCount++
        if (booking.petType === 'dog') dogCount++
      }
    })

    return { cat: catCount, dog: dogCount }
  }

  const getTodayBookings = () => {
    const today = new Date()
    const todayNormalized = new Date(today.getFullYear(), today.getMonth(), today.getDate())

    return bookings.filter(booking => {
      const checkIn = new Date(booking.checkIn.getFullYear(), booking.checkIn.getMonth(), booking.checkIn.getDate())
      const checkOut = new Date(booking.checkOut.getFullYear(), booking.checkOut.getMonth(), booking.checkOut.getDate())

      return checkIn <= todayNormalized && checkOut > todayNormalized
    })
  }

  const value = {
    bookings,
    addBooking,
    deleteBooking,
    getCapacityCount,
    getTodayBookings,
  }

  return (
    <BookingContext.Provider value={value}>
      {children}
    </BookingContext.Provider>
  )
}