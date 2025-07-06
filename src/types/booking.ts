export interface Booking {
  id: string
  petName: string
  petType: 'cat' | 'dog'
  ownerName: string
  ownerPhone: string
  checkIn: Date
  checkOut: Date
  notes?: string
  createdAt: Date
}

export interface BookingFormData {
  petName: string
  petType: 'cat' | 'dog'
  ownerName: string
  ownerPhone: string
  checkIn: Date
  checkOut: Date
  notes?: string
}