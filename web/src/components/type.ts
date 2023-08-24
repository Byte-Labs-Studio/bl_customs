import React, { ReactNode } from 'react';

interface CardProps {
    icon: () => ReactNode;
    text: string,
    yellow?: boolean,
    style?: React.CSSProperties,
    selected?: boolean,
    price?: number,
    applied? : boolean
}

interface TargetMenuData { 
    mod: string, 
    price?: number, 
    toggle?: boolean, 
    applied?: boolean 
}

interface MenuProps {
    type: 'menu'|'modType'|'modIndex',
    current: string,
    previous: string,
    currentMenu: string,
    data: {
        id: string,
        label: string
        selected?: boolean
        price?: number
        applied? : boolean
        icon? : () => ReactNode;
        toggle?: boolean
    }[]
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

export type {CardProps, CardsContextProps, MenuProps, ListProps, TargetMenuData}
