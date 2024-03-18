import React from 'react';
import MainContainer from "./MainContainer";
import { CardsProvider } from "./CardsContext";
import CameraHandle from "./CameraHandle";

const Customs: React.FC = () => {
  return (
    <>
      <CameraHandle />
      <CardsProvider>
        <MainContainer />
      </CardsProvider>
    </>
  );
}

export default Customs;
