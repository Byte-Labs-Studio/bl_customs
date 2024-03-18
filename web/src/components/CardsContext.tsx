import React, {
    PropsWithChildren,
    createContext,
    useMemo,
    useState,
    useEffect,
} from "react";
import { CardsContextProps, MenuProps, MenuItem } from "./type";
import { useNuiEvent } from "../hooks/useNuiEvent";
import DEFAULT from "./DEFAULT_DATA";
import { fetchNui } from "../utils/fetchNui";

const CardsContext = createContext<CardsContextProps>({} as CardsContextProps);

export const CardsProvider: React.FC<PropsWithChildren> = ({ children }) => {
    const [menu, setMenuData] = useState<MenuProps>(DEFAULT);

    useEffect(() => {
        fetchNui<string[]>("customsLoaded")
            .then((colorTypes) => {
                if (!colorTypes) return
                setMenuData({ ...menu, colorMenus: colorTypes })
            })
    }, []);

    useNuiEvent<MenuItem[]>("setZoneMods", (mods) => {
        const mainMenus = []
        for (const item of mods) {
            mainMenus.push(item.id)
        }
        setMenuData({ ...menu, data: mods, mainMenus: mainMenus, defaultMenu: mods})
    });

    const contextValue = useMemo(() => ({ menu, setMenuData }), [menu]);
    return (
        <CardsContext.Provider value={contextValue}>
            {children}
        </CardsContext.Provider>
    );
};

export default CardsContext;
