import React, { useMemo, useRef, useEffect } from 'react';
import { CardProps } from "./type";
import {faCheck} from '@fortawesome/free-solid-svg-icons'
import {Icon} from './Icon'


const Card: React.FC<CardProps> = React.memo(({ icon, text, style, yellow, selected, price, applied }) => {
  const cardStyle = useMemo(() => ({ ...style }), [style]);
  const cardRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (selected && cardRef.current) {
      cardRef.current.scrollIntoView({ behavior: "smooth", block: "center", inline: "center" });
    }
  }, [cardRef, selected]);

  return (
    <div ref={selected ? cardRef : null} className={'cards ' + (yellow ? 'yellow ' : '') + (selected ? 'cardsHover' : '')} style={cardStyle}>
      {applied && <span className='card-applied'>{Icon(faCheck, 'sm')}</span>}
      {price && <p className='card-price'>${price}</p>}
      <div className='cards-center-content'>
        {icon()}
        <p className='card-text'>
        {text}
        </p>
      </div>
    </div>
  )
});

export default Card;
