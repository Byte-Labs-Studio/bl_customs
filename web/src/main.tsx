import React from 'react';
import ReactDOM from 'react-dom/client';
import Customs from './components/Customs';
import { VisibilityProvider } from './providers/VisibilityProvider';
import './components/Customs.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <VisibilityProvider>
      <Customs />
    </VisibilityProvider>
  </React.StrictMode>,
);
