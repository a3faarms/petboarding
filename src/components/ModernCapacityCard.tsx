import React from 'react'
import { LucideIcon } from 'lucide-react'

interface ModernCapacityCardProps {
  title: string
  current: number
  total: number
  icon: LucideIcon
  gradient: string
  accentColor: string
}

const ModernCapacityCard: React.FC<ModernCapacityCardProps> = ({
  title,
  current,
  total,
  icon: Icon,
  gradient,
  accentColor,
}) => {
  const percentage = total > 0 ? (current / total) * 100 : 0

  return (
    <div className={`${gradient} p-6 rounded-2xl shadow-lg text-white relative overflow-hidden`}>
      <div className="flex justify-between items-start mb-5">
        <div className="bg-white/20 p-3 rounded-xl">
          <Icon size={24} />
        </div>
        <div className="bg-white/20 px-3 py-1 rounded-full text-sm font-semibold">
          {Math.round(percentage)}%
        </div>
      </div>
      
      <h3 className="text-lg font-medium mb-2">{title}</h3>
      
      <div className="flex items-end space-x-1 mb-4">
        <span className="text-4xl font-bold">{current}</span>
        <span className="text-xl text-white/80 pb-1">/ {total}</span>
      </div>
      
      <div className="w-full bg-white/30 rounded-full h-2">
        <div 
          className="bg-white rounded-full h-2 transition-all duration-300"
          style={{ width: `${Math.min(percentage, 100)}%` }}
        />
      </div>
    </div>
  )
}

export default ModernCapacityCard