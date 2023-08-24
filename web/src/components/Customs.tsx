import React from 'react';
import MainContainer from "./MainContainer";
import { CardsProvider } from "./CardsContext";
import { VisibilityProvider } from './../providers/VisibilityProvider';
import './Customs.css'

const Customs: React.FC = () => {
  return (
    <VisibilityProvider removal>
      <CardsProvider>
        <MainContainer />
      </CardsProvider>
    </VisibilityProvider>
  );
}

export default Customs;
