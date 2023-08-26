import React, {WheelEvent} from 'react';
import { fetchNui } from "../utils/fetchNui";

const CameraHandle: React.FC = () => {
    const [mouseMovement, setMouseMovement] = React.useState(false)

    const wheelHandler = (event: WheelEvent) => {
        let y = event.deltaY > 0 ? 0.5 : -0.5
        fetchNui('cameraHandle', {type: 'wheel', coords: y})
    }

    const mouseMoveHandler = (event: React.MouseEvent<HTMLDivElement, MouseEvent>) => {
		let x = event.movementX / 8
		let y = event.movementY / 8
        fetchNui('cameraHandle', {type: 'mouse', coords:{x: x, y: y}})
    }
    return (
        <div
            className='camera-handle'
            onMouseDown={() => setMouseMovement(true)}
            onMouseUp={() => setMouseMovement(false)}
            onWheel={wheelHandler}
            onMouseMove={(e) => mouseMovement ? mouseMoveHandler(e): null}
        ></div>
    );
}

export default CameraHandle;
