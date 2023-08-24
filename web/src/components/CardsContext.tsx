import React, { PropsWithChildren, createContext, useMemo, useState } from 'react';
import { CardsContextProps, MenuProps } from "./type";
import DEFAULT from './DEFAULT_DATA'

const CardsContext = createContext<CardsContextProps>({} as CardsContextProps);

export const CardsProvider: React.FC<PropsWithChildren> = ({ children }) => {
    const [menu, setMenuData] = useState<MenuProps>(DEFAULT);

    const contextValue = useMemo(() => ({ menu, setMenuData }), [menu]);
    return <CardsContext.Provider value={contextValue}>{children}</CardsContext.Provider>
}

export default CardsContext
