import React from 'react';

interface CardProps {
    icon: string;
    text: string;
    yellow?: boolean;
    style?: React.CSSProperties;
    selected?: boolean;
    price?: number;
    applied?: boolean;
}

interface TargetMenuData {
    mod: string,
    price?: number,
    toggle?: boolean,
    applied?: boolean,
    icon?:string
}

interface MenuItem {
    id: string;
    label: string;
    selected?: boolean;
    price?: number;
    applied?: boolean;
    icon?: string;
    toggle?: boolean;
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
