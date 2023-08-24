import React, { useContext, useMemo, useEffect, useState } from 'react';
import CardsContext from "./CardsContext";
import { Icon } from "./Icon";
import handleClick from "./MenuClick";
import Card from "./Card";
import { faCar, faFillDrip } from '@fortawesome/free-solid-svg-icons'
import useKeyPress from '../hooks/useKeyPress'
import { fetchNui } from "../utils/fetchNui";
import WheelsSvg from './SVG/Wheels'
import DecalsSvg from './SVG/Decals'
import { TargetMenuData } from "./type";


const MainContainer: React.FC = () => {
  const { setMenuData, menu } = useContext(CardsContext);

  if (menu.current === 'exit') return null
  const arrowsClick = useKeyPress(['ArrowRight', 'ArrowLeft'], true);
  const enterClick = useKeyPress('Enter');
  const backspace = useKeyPress('Backspace');
  const [selected, setSelected] = useState<TargetMenuData>({mod: ''})

  useEffect(() => {
    if (backspace) handleClick({mod: 'back'}, menu, setMenuData)
    if (enterClick && selected.mod !== '') handleClick(selected, menu, setMenuData)
    if (arrowsClick) {
      const updatedData = [...menu.data];
      const foundSelected = menu.data.find(obj => obj.selected === true);
      const selectedIndex = foundSelected ? menu.data.indexOf(foundSelected) : 0;
      const directionMultiplier = arrowsClick === 'ArrowRight' ? (selectedIndex + 1) : (selectedIndex - 1 + menu.data.length);
      const nextIndex = directionMultiplier % menu.data.length
      const nextObject = updatedData[nextIndex]
      const isToggle = nextObject.toggle 
      updatedData[selectedIndex].selected = false;
      nextObject.selected = true;
      if (typeof nextObject.id === 'number' && !isToggle) fetchNui('applyMod', nextObject.id)
      setMenuData({ ...menu, data: updatedData });
    }
  }, [backspace, enterClick, arrowsClick]);

  const RenderCards = useMemo(() => {
    let icon = menu.currentMenu === 'decals' && DecalsSvg || menu.currentMenu === 'wheels' && WheelsSvg || menu.currentMenu === 'paint' && (() => Icon(faFillDrip)) || (() => Icon(faCar))
    return menu.data.map((value, index) => {
      if (value.selected) setSelected({mod: value.id, price: value.price, toggle: value.toggle, applied: value.applied})
      let label = value.id
      if (typeof value.id === 'number') label = value.label
      return (
        <Card key={index} icon={value.icon || icon} text={label[0].toUpperCase() + label.slice(1)} selected={value.selected} price={value.price || undefined} applied={value.applied || undefined} yellow={value.id === 'exit'}/>
      )
    })
  }, [menu]);

  return (
    <div className="customs-wrapper">
      <div className='cards-wrapper'>
        <div className="flexbox">
          {RenderCards}
        </div>
      </div>
    </div>
  );
}

export default MainContainer;
