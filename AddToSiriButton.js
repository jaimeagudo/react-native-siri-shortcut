// @flow
import type { ShortcutOptions } from ".";

import * as React from "react";
import { requireNativeComponent, StyleSheet, Platform } from "react-native";

const RNTAddToSiriButton = Platform.select({
  ios: requireNativeComponent("RNTAddToSiriButton")
});

export const SiriButtonStyles = {
  white: 0,
  whiteOutline: 1,
  black: 2,
  blackOutline: 3
};

type ViewProps = React.ElementConfig<typeof View>;
type ViewStyleProp = $PropertyType<ViewProps, "style">;

type Props = {
  buttonStyle?: 0 | 1 | 2 | 3,
  style?: ViewStyleProp,
  shortcut: ShortcutOptions,
  onPress?: () => void
};

const AddToSiriButton = ({
  buttonStyle = SiriButtonStyles.blackOutline,
  style = {},
  onPress = () => {},
  shortcut
}: Props) => (
  <RNTAddToSiriButton
    buttonStyle={buttonStyle}
    style={[{ height: 50 }, style]}
    onPress={onPress}
    shortcut={shortcut}
  />
);

export default AddToSiriButton;
