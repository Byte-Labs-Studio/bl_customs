import {ReactNode} from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { IconProp, SizeProp } from '@fortawesome/fontawesome-svg-core';

export const Icon = (icon:IconProp, size?: SizeProp): ReactNode => {
    return <FontAwesomeIcon icon={icon} size={size || "2xl"} beat className='card-icon' />
}

