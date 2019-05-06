import React from "react";

export const ShowIf = React.memo(({ condition, children }) => condition ? children : null);
