import React, { useContext, useMemo, useEffect, useState } from "react";
import CardsContext from "./CardsContext";
import handleClick from "./MenuClick";
import Card from "./Card";
import useKeyPress from "../hooks/useKeyPress";
import { fetchNui } from "../utils/fetchNui";
import { TargetMenuData } from "./type";

const upperCase = (text: string) => {
  return text[0].toUpperCase() + text.slice(1);
};

const MainContainer: React.FC = () => {
  const { setMenuData, menu } = useContext(CardsContext);
  const keyPress = useKeyPress(["ArrowRight", "ArrowLeft", "Enter", "Backspace"],true);
  if (menu.card.current === "exit") return null;

  const [selected, setSelected] = useState<TargetMenuData>({ mod: "" });
  const [cardsCount, setCardsCount] = useState<{
    total: number;
    current: number;
  }>({ total: 0, current: 0 });

  useEffect(() => {
    if (keyPress == "Backspace")
      handleClick({ mod: "back" }, menu, setMenuData);
    else if (keyPress == "Enter" && selected.mod !== "")
      handleClick(selected, menu, setMenuData);
    else if (keyPress == "ArrowRight" || keyPress == "ArrowLeft") {
      const updatedData = [...menu.data];
      const foundSelected = menu.data.find((obj) => obj.selected === true);
      const selectedIndex = foundSelected ? menu.data.indexOf(foundSelected) : 0;
      let nextIndex = keyPress === "ArrowRight" ? (selectedIndex + 1) % menu.data.length : (selectedIndex - 1 + menu.data.length) % menu.data.length;
      while (updatedData[nextIndex]?.hide) {
          nextIndex = (nextIndex + (keyPress === "ArrowRight" ? 1 : -1) + menu.data.length) % menu.data.length;
      }
      let nextObject = updatedData[nextIndex];
      const isToggle = nextObject.toggle;

      updatedData[selectedIndex].selected = false;
      nextObject.selected = true;

      if (typeof nextObject.id === "number" && !isToggle)
        fetchNui("applyMod", nextObject.id);
      setMenuData({ ...menu, data: updatedData });
    }
  }, [keyPress]);

  useEffect(() => {
    if (menu.data.length <= 0) return;
    const updatedData = [...menu.data];
    const selectedData = updatedData.find((obj) => obj.selected === true);
  
    if (!selectedData || selectedData.hide) {
      const index = updatedData.findIndex(obj => !obj.hide);
      if (index !== -1) {
        updatedData.forEach((obj, index) => {
          updatedData[index] = { ...obj, selected: false };
        });
        updatedData[index] = { ...updatedData[index], selected: true };
        setMenuData(prevMenu => ({ ...prevMenu, data: updatedData }));
        return;
      }
    }
  
    if (selectedData) {
      setSelected({
        mod: selectedData.id,
        price: selectedData.price,
        toggle: selectedData.toggle,
        applied: selectedData.applied,
        icon: selectedData.icon,
        menuType: selectedData.menuType,
      });
      setCardsCount({ total: menu.data.length, current: 1 });
    }
  }, [menu, setMenuData, setSelected, setCardsCount]);

  const RenderCards = useMemo(() => {
    return menu.data.map((value, index) => {
      if (!value.hide) {
        let label = value.label || value.id;
        return (
          <Card
            key={index}
            icon={value.icon || menu.icon || "car"}
            text={upperCase(label)}
            selected={value.selected}
            price={value.price || undefined}
            applied={value.applied || undefined}
            yellow={value.id === "exit"}
          />
        );
      }
    });
  }, [menu]);

  return (
    <div className="customs-wrapper">
      <div className="cards-swapper">
        {upperCase(menu.card.current)}
        <p className="cards-count">
          {cardsCount.current}/{cardsCount.total}
        </p>
      </div>
      <div className="cards-wrapper">
        <div className="flexbox">{RenderCards}</div>
      </div>
    </div>
  );
};

export default MainContainer;
