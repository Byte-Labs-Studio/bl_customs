import { fetchNui } from "../utils/fetchNui";
import { MenuProps, CardsContextProps, TargetMenuData } from "./type";
import DEFAULT from './DEFAULT_DATA'

const mainMenus = ['preview', 'wheels', 'paint', 'decals', 'exit']
const colorMenus = ['Primary', 'Secondary', 'Extra', 'Dashboard', 'Interior', 'Neon', 'Tyre Smoke', 'Xenon Lights']

const handleClick = async (targetMenuData: TargetMenuData, menu: MenuProps, setMenuData: CardsContextProps['setMenuData']) => {
    const targetMenu = targetMenuData.mod
    const isBackButton = targetMenu === 'back'
    if (targetMenu === 'back' && menu.previous === 'main') {
        if (menu.current === 'main') {
            fetchNui<MenuProps['data']>('setMenu', { clickedCard: 'exit', type: 'menu' })
            return
        }
        setMenuData(DEFAULT)
    } else {
        const clickedCard = targetMenu === 'back' ? menu.previous : targetMenu
        const type = mainMenus.includes(clickedCard) ? 'menu' : typeof targetMenu === 'number' ? 'modIndex' : 'modType'
        if (type === 'modIndex') {
            const success = targetMenuData.toggle ? fetchNui('toggleMod', { mod: clickedCard, price: targetMenuData.price || 0, toggle: !targetMenuData.applied }) : fetchNui('buyMod', { mod: clickedCard, price: targetMenuData.price || 0 })
            success.then(response => {
                if (!response) return
                const updatedData = menu.data.map(obj => ({ ...obj }));
                const targetIndex = updatedData.findIndex(obj => obj.id === targetMenu);

                if (targetIndex === -1) return;

                if (targetMenuData.toggle) updatedData[targetIndex].applied = !targetMenuData.applied;
                else updatedData.forEach(obj => { obj.applied = obj.id === targetMenu })

                setMenuData({
                    ...menu,
                    data: updatedData,
                });
            }).catch(error => {
                console.error(error);
            });
            return
        }

        const previousMenu = targetMenu === 'back' ? mainMenus.includes(menu.previous) ? 'main' : colorMenus.includes(menu.previous) ? 'paint' : menu.previous : menu.current
        const currentMenu = type === 'menu' ? clickedCard : menu.currentMenu

        const data = await fetchNui<MenuProps['data']>('setMenu', { clickedCard: clickedCard, type: type, isBack: isBackButton })
        if (typeof data === 'object') setMenuData({ type: type, current: clickedCard, previous: previousMenu, data: data, currentMenu: currentMenu })
    }
}

export default handleClick;
