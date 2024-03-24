import { fetchNui } from "../utils/fetchNui";
import { MenuProps, CardsContextProps, TargetMenuData } from "./type";

const handleClick = async (
  targetMenuData: TargetMenuData,
  menu: MenuProps,
  setMenuData: CardsContextProps['setMenuData'],
) => {
    const targetMenu = targetMenuData.mod
    const isBackButton = targetMenu === 'back'
    const card = menu.card
    if (isBackButton && card.previous === 'main') {
        if (card.current === 'main') fetchNui<MenuProps['data']>('setMenu', { clickedCard: 'exit', cardType: 'menu' })
        else setMenuData({...menu, data: menu.defaultMenu, type: 'menu', card: {current: 'main', previous: 'main'}, currentMenu: 'main'})
        return
    } else {
        const clickedCard = isBackButton ? card.previous : targetMenu
        const type = menu.mainMenus.includes(clickedCard) ? 'menu' : typeof targetMenu === 'number' ? 'modIndex' : 'modType'
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
        const currentMenu = type === 'menu' ? clickedCard : menu.currentMenu
        const previousMenu = isBackButton ? menu.mainMenus.includes(card.previous) ? 'main' : menu.colorMenus.includes(card.previous) ? currentMenu : card.previous : card.current

        const data = await fetchNui<MenuProps['data']>('setMenu', { clickedCard: clickedCard, cardType: type, isBack: isBackButton, menuType: targetMenuData.menuType })
        if (typeof data === 'object') setMenuData({...menu, type: type, card: {current: clickedCard, previous: previousMenu}, data: data, currentMenu: currentMenu, icon: targetMenuData.icon})
    }
}

export default handleClick;
