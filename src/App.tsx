import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { BookingProvider } from './contexts/BookingContext'
import HomePage from './pages/HomePage'
import BookingFormPage from './pages/BookingFormPage'
import BookingListPage from './pages/BookingListPage'

function App() {
  return (
    <BookingProvider>
      <Router>
        <div className="min-h-screen bg-gray-50">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/booking" element={<BookingFormPage />} />
            <Route path="/bookings" element={<BookingListPage />} />
          </Routes>
          <Toaster 
            position="top-right"
            toastOptions={{
              duration: 4000,
              style: {
                background: '#363636',
                color: '#fff',
              },
            }}
          />
        </div>
      </Router>
    </BookingProvider>
  )
}

export default App