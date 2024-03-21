import React from 'react';


interface Item {
    price?: number;
    applied?: boolean;
    menuType?: string,
    icon?: string;
    toggle?: boolean;
}

interface CardProps {
    icon: string;
    text: string;
    price?: number;
    applied?: boolean;
    yellow?: boolean;
    style?: React.CSSProperties;
    selected?: boolean;
}

interface TargetMenuData extends Item {
    mod: string,
}

interface MenuItem extends Item {
    id: string;
    label: string;
    selected?: boolean;
    hide?: boolean
}

interface MenuProps {
    type: 'menu' | 'modType' | 'modIndex',
    currentMenu: string,
    data: MenuItem[],
    defaultMenu: MenuItem[]
    mainMenus: string[],
    colorMenus: string[]
    card: {
        current: string,
        previous: string,
    }
    icon?: string
}

interface ListProps {
    mod: string;
    type: string;
    label: string;
    price: number
}

interface CardsContextProps {
    menu: MenuProps;
    setMenuData: React.Dispatch<React.SetStateAction<MenuProps>>;
}

export type { CardProps, CardsContextProps, MenuProps, ListProps, TargetMenuData, MenuItem }
