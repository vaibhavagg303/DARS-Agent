import 'styled-components';

declare module 'styled-components' {
  export interface DefaultTheme {
    bg: string;
    primary: string;
    nodeBg: string;
    nodeColor: string;
    nodeBorder: string;
    minimapMaskBg: string;
    controlsBg: string;
    controlsBgHover: string;
    controlsColor: string;
    controlsBorder: string;
    isDarkMode?: boolean;
  }
}
