import React, { useMemo, useRef, useEffect } from 'react';
import { CardProps } from "./type";
import { Icon } from './Icon'
import { IconName } from '@fortawesome/fontawesome-svg-core'

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
      {applied && <span className='card-applied'>{Icon('check', 'sm')}</span>}
      {price && <p className='card-price' style={{ color: selected ? '#282c34' : 'white' }}>${price}</p>}
      <div className='cards-center-content'>
        {Icon(icon as IconName)}
        <p className='card-text'>
          {text}
        </p>
      </div>
    </div>
  )
});

export default Card;
