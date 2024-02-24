import React, { PropsWithChildren, createContext, useMemo, useState } from 'react';
import { CardsContextProps, MenuProps } from "./type";
import { useNuiEvent } from "../hooks/useNuiEvent";
import DEFAULT from './DEFAULT_DATA'

const CardsContext = createContext<CardsContextProps>({} as CardsContextProps);

export const CardsProvider: React.FC<PropsWithChildren> = ({ children }) => {
    const [menu, setMenuData] = useState<MenuProps>(DEFAULT);

    useNuiEvent<{[key: string]: boolean}>("setZoneMods", (mods) => {
        const clonedObject = { ...DEFAULT };
        for (let i = clonedObject.data.length - 1; i >= 0; i--) {
            const element = clonedObject.data[i];
            if (!mods[element.id] && element.id !== 'preview' && element.id !== 'exit') clonedObject.data.splice(i, 1);
        }
        setMenuData(clonedObject);
    });

    const contextValue = useMemo(() => ({ menu, setMenuData }), [menu]);
    return <CardsContext.Provider value={contextValue}>{children}</CardsContext.Provider>
}

export default CardsContext
