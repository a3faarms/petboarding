import React from 'react'
import { Trash2, User, Phone, Calendar, FileText } from 'lucide-react'
import { format } from 'date-fns'
import { Booking } from '../types/booking'

interface ModernBookingCardProps {
  booking: Booking
  onDelete?: () => void
  onTap?: () => void
}

const ModernBookingCard: React.FC<ModernBookingCardProps> = ({
  booking,
  onDelete,
  onTap,
}) => {
  const isPetCat = booking.petType === 'cat'
  const petColor = isPetCat ? 'text-cat-primary' : 'text-dog-primary'
  const petBgColor = isPetCat ? 'bg-cat-secondary' : 'bg-dog-secondary'

  return (
    <div 
      className="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer"
      onClick={onTap}
    >
      <div className="flex items-start justify-between mb-5">
        <div className="flex items-center space-x-4">
          <div className={`${petBgColor} p-3 rounded-xl`}>
            <div className={`w-6 h-6 ${petColor}`}>🐾</div>
          </div>
          <div>
            <h3 className="text-xl font-bold text-gray-900">{booking.petName}</h3>
            <span className={`inline-block ${petBgColor} ${petColor} px-2 py-1 rounded-lg text-xs font-semibold uppercase tracking-wide mt-1`}>
              {booking.petType}
            </span>
          </div>
        </div>
        {onDelete && (
          <button
            onClick={(e) => {
              e.stopPropagation()
              onDelete()
            }}
            className="p-2 text-red-500 hover:bg-red-50 rounded-lg transition-colors"
          >
            <Trash2 size={20} />
          </button>
        )}
      </div>

      <div className="space-y-3">
        <InfoRow icon={User} label="Owner" value={booking.ownerName} />
        <InfoRow icon={Phone} label="Phone" value={booking.ownerPhone} />
        <InfoRow 
          icon={Calendar} 
          label="Stay Period" 
          value={`${format(booking.checkIn, 'MMM d, yyyy')} → ${format(booking.checkOut, 'MMM d, yyyy')}`} 
        />
        {booking.notes && (
          <InfoRow icon={FileText} label="Notes" value={booking.notes} />
        )}
      </div>
    </div>
  )
}

interface InfoRowProps {
  icon: React.ComponentType<{ size?: number }>
  label: string
  value: string
}

const InfoRow: React.FC<InfoRowProps> = ({ icon: Icon, label, value }) => (
  <div className="flex items-start space-x-3">
    <Icon size={18} className="text-gray-400 mt-0.5" />
    <div className="flex-1">
      <p className="text-sm font-medium text-gray-500">{label}</p>
      <p className="text-sm text-gray-900 font-medium">{value}</p>
    </div>
  </div>
)

export default ModernBookingCard