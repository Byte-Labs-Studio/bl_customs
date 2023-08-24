import {useEffect, useCallback, useState} from 'react';


export const useKeyPress = (targetKey: KeyboardEvent['key'] | Array<KeyboardEvent['key']>, preventDef? : boolean) => {
  const [keyPressed, setKeyPressed] = useState<boolean | string>(false);

  const downHandler = useCallback(
    (event: KeyboardEvent) => {
      if (preventDef) event.preventDefault();
      if (typeof targetKey === 'object' && targetKey.includes(event.key)) setKeyPressed(event.key);
      else if (event.key === targetKey) setKeyPressed(true);
    },
    [targetKey, preventDef]
  );


  const upHandler = useCallback(
    ({ key }: KeyboardEvent) => {
      if ((typeof targetKey === 'object' && targetKey.includes(key)) || key === targetKey) setKeyPressed(false);
    },
    [targetKey]
  );

  useEffect(() => {
    window.addEventListener('keydown', downHandler);
    window.addEventListener('keyup', upHandler);

    return () => {
      window.removeEventListener('keydown', downHandler);
      window.removeEventListener('keyup', upHandler);
    };
  }, [downHandler, upHandler]);

  return keyPressed;
};


export default useKeyPress;