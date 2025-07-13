import React, { useState, useEffect } from 'react';
import SpeechRecognition, { useSpeechRecognition } from 'react-speech-recognition';
import { createBooking } from '../api/bookings';

interface BookingPayload {
  pet_name: string;
  owner_name: string;
  owner_phone: string;
  start_date: string;
  end_date: string;
  pet_type: string;
  special_notes?: string;
}

const steps = [
  { key: 'pet_name', question: "What's your pet's name?" },
  { key: 'owner_name', question: "Who is the owner?" },
  { key: 'owner_phone', question: "What's the owner's phone number?" },
  { key: 'start_date', question: "What is the start date? Say in YYYY-MM-DD format." },
  { key: 'end_date', question: "What is the end date? Say in YYYY-MM-DD format." },
  { key: 'pet_type', question: "What kind of pet is it? Dog, cat, etc.?" },
  { key: 'special_notes', question: "Any special instructions?" },
];

const VoiceBooking: React.FC = () => {
  const [currentStep, setCurrentStep] = useState(0);
  const [bookingData, setBookingData] = useState<Partial<BookingPayload>>({});
  const [isBooking, setIsBooking] = useState(false);

  const {
    transcript,
    listening,
    resetTranscript,
    browserSupportsSpeechRecognition,
  } = useSpeechRecognition();

  // Speak the current question
  const speak = (text: string) => {
    const utterance = new SpeechSynthesisUtterance(text);
    speechSynthesis.speak(utterance);
  };

  const startVoiceFlow = () => {
    setCurrentStep(0);
    setBookingData({});
    setIsBooking(true);
    resetTranscript();
    setTimeout(() => speak(steps[0].question), 1000);
    setTimeout(() => SpeechRecognition.startListening({ continuous: false }), 2500);
  };

  // Handle each step's answer
  useEffect(() => {
    if (!listening && transcript && isBooking) {
      const step = steps[currentStep];
      setBookingData((prev) => ({
        ...prev,
        [step.key]: transcript.trim(),
      }));

      resetTranscript();

      const nextStep = currentStep + 1;

      if (nextStep < steps.length) {
        setCurrentStep(nextStep);
        setTimeout(() => speak(steps[nextStep].question), 1000);
        setTimeout(() => SpeechRecognition.startListening({ continuous: false }), 2500);
      } else {
        // All questions answered → submit booking
        submitBooking({ ...bookingData, [step.key]: transcript.trim() } as BookingPayload);
        setIsBooking(false);
      }
    }
  }, [listening]);

  const submitBooking = async (data: BookingPayload) => {
    speak('Submitting your booking now.');
    const result = await createBooking(data);
    if (result.success) {
      speak('Your booking has been confirmed. Thank you!');
    } else {
      speak('Something went wrong while booking. Please try again.');
    }
  };

  if (!browserSupportsSpeechRecognition) {
    return <p>Your browser does not support speech recognition.</p>;
  }

  return (
    <div style={{ padding: '2rem', background: '#eee', border: '2px solid red' }}>
      <h2>Voice Facilitator</h2>
      <button onClick={startVoiceFlow} disabled={isBooking}>
        🎤 Start Voice Booking
      </button>
      {isBooking && <p>Listening for: {steps[currentStep].key}</p>}
    </div>
  );
};

export default VoiceBooking;
