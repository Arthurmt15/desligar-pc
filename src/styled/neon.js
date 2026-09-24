import styled, { keyframes, createGlobalStyle } from 'styled-components';

const flicker = keyframes`
  0%,100% { opacity: 1; }
  50% { opacity: 0.85; }
`;

const shimmer = keyframes`
  0% { transform: translateX(-100%); }
  100% { transform: translateX(300%); }
`;

export const NeonGlobal = createGlobalStyle`
  ::selection { background: rgba(0,240,255,0.3); color: white; }
`;

export const NeonCard = styled.div`
  position: relative;
  background: rgba(6, 8, 18, 0.85);
  border: 1px solid rgba(0, 240, 255, 0.15);
  backdrop-filter: blur(12px);
  clip-path: polygon(0 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%);
  box-shadow: 0 0 30px rgba(0, 240, 255, 0.05), inset 0 1px 0 rgba(255,255,255,0.06);
  overflow: hidden;
  &::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0; height: 1px;
    background: linear-gradient(90deg, transparent, rgba(0,240,255,0.2), transparent);
  }
`;

export const NeonButton = styled.button`
  position: relative;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 900;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  padding: 16px 24px;
  width: 100%;
  border: 1px solid rgba(255,255,255,0.2);
  background: linear-gradient(90deg, #00F0FF 0%, #7000FF 50%, #FF00A8 100%);
  color: black;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.2s;
  &:hover {
    box-shadow: 0 0 30px rgba(0,240,255,0.5), 0 0 30px rgba(255,0,168,0.3);
    transform: scale(1.01);
  }
  &:active { transform: scale(0.99); }
  &:disabled { opacity: 0.5; cursor: not-allowed; }
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
    transform: translateX(-100%);
    transition: transform 0.7s;
  }
  &:hover::after { transform: translateX(100%); }
`;

export const NeonBadge = styled.span`
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 12px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  font-weight: 900;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  background: black;
  border: 1px solid ${p => p.$scheduled ? 'rgba(255,0,168,0.4)' : 'rgba(0,240,255,0.3)'};
  color: ${p => p.$scheduled ? '#FF00A8' : '#00F0FF'};
  box-shadow: 0 0 12px ${p => p.$scheduled ? 'rgba(255,0,168,0.3)' : 'rgba(0,240,255,0.2)'};
  & > i {
    width: 8px; height: 8px; border-radius: 50%;
    background: ${p => p.$scheduled ? '#FF00A8' : '#00F0FF'};
    box-shadow: 0 0 8px ${p => p.$scheduled ? '#FF00A8' : '#00F0FF'};
    animation: ${flicker} 1.5s infinite;
  }
`;

export const NeonProgressWrap = styled.div`
  height: 10px;
  background: black;
  border: 1px solid rgba(0,240,255,0.15);
  padding: 3px;
  position: relative;
  overflow: hidden;
`;

export const NeonProgressBar = styled.div`
  height: 100%;
  background: linear-gradient(90deg, #00F0FF, #7000FF, #FF00A8);
  box-shadow: 0 0 12px rgba(0,240,255,0.6);
  width: ${p => p.$pct}%;
  transition: width 1s linear;
  position: relative;
  overflow: hidden;
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
    width: 40px;
    animation: ${shimmer} 1.2s infinite;
  }
`;

export const NeonFeedback = styled.p`
  font-family: 'JetBrains Mono', monospace;
  font-size: 13px;
  font-weight: 700;
  text-align: center;
  min-height: 20px;
  letter-spacing: 0.04em;
  color: ${p => p.$type === 'error' ? '#FF0040' : p.$type === 'success' ? '#00F0FF' : 'rgba(0,240,255,0.6)'};
  text-shadow: ${p => p.$type === 'error' ? '0 0 8px rgba(255,0,64,0.5)' : p.$type === 'success' ? '0 0 8px rgba(0,240,255,0.6)' : 'none'};
`;

export const GridBg = styled.div`
  position: fixed;
  inset: 0;
  z-index: -10;
  background: #02020a;
  &::before {
    content: '';
    position: absolute;
    inset: 0;
    opacity: 0.08;
    background-image: linear-gradient(rgba(0,240,255,0.5) 1px, transparent 1px), linear-gradient(90deg, rgba(0,240,255,0.5) 1px, transparent 1px);
    background-size: 48px 48px;
  }
`;
