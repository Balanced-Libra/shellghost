import { TextAttributes } from "@opentui/core"
import { For } from "solid-js"
import { useTheme } from "@tui/context/theme"

const LOGO = [
  `                            S H E L L G H O S T`,
  ``,
  `   ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗███████╗██╗  ██╗███████╗██╗     ██╗`,
  `  ██╔════╝ ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝██╔════╝██║  ██║██╔════╝██║     ██║`,
  `  ██║  ███╗███████║██║   ██║███████╗   ██║   ███████╗███████║█████╗  ██║     ██║`,
  `  ██║   ██║██╔══██║██║   ██║╚════██║   ██║   ╚════██║██╔══██║██╔══╝  ██║     ██║`,
  `  ╚██████╔╝██║  ██║╚██████╔╝███████║   ██║   ███████║██║  ██║███████╗███████╗███████╗`,
  `   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝`,
  ``,
  `                 "Hauntingly capable. Unreasonably authorized."`,
]

export function Logo() {
  const { theme } = useTheme()
  return (
    <box>
      <For each={LOGO}>
        {(line, index) => (
          <text
            fg={index() === 0 || index() === LOGO.length - 1 ? theme.textMuted : theme.text}
            attributes={index() > 1 && index() < 8 ? TextAttributes.BOLD : undefined}
            selectable={false}
          >
            {line}
          </text>
        )}
      </For>
    </box>
  )
}
