import { MenuProps} from "./type";

const default_data = { type: 'menu', card: {current: 'main', previous: 'main'}, data: [
    {id: 'preview', selected: true, label: 'Preview', icon: 'car-side'},
    {id: 'decals', label: 'Decals', icon: 'screwdriver-wrench'},
    {id: 'wheels', label: 'Wheels', icon: 'tire'},
    {id: 'paint', label: 'Paint', icon: 'fill-drip'},
    {id: 'exit', label: 'Exit', icon: 'right-from-bracket'},
], currentMenu: 'main'} as MenuProps

export default default_data