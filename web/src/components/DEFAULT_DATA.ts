import WheelsSvg from './SVG/Wheels'
import DecalsSvg from './SVG/Decals'
import PreviewSvg from './SVG/Preview'
import {Icon} from './Icon'
import {faFillDrip, faRightFromBracket} from '@fortawesome/free-solid-svg-icons'
import { MenuProps} from "./type";

const default_data = { type: 'menu', current: 'main', previous: 'main', data: [
    {id: 'preview', selected: true, label: 'Preview', icon: PreviewSvg},
    {id: 'decals', label: 'Decals', icon: DecalsSvg},
    {id: 'wheels', label: 'Wheels', icon: WheelsSvg},
    {id: 'paint', label: 'Paint', icon: () => Icon(faFillDrip)},
    {id: 'exit', label: 'Exit', icon: () => Icon(faRightFromBracket)},
], currentMenu: 'main'} as MenuProps

export default default_data