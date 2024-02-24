import React, {useEffect} from 'react';
import MainContainer from "./MainContainer";
import { CardsProvider } from "./CardsContext";
import CameraHandle from "./CameraHandle";
import { fetchNui } from "../utils/fetchNui";

const Customs: React.FC = () => {
  useEffect(() => {
    fetchNui<{[key: string]: boolean}>("customsLoaded")
  }, []);

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
