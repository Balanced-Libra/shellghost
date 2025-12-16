import { TextAttributes } from "@opentui/core"
import { For } from "solid-js"
import { useTheme } from "@tui/context/theme"

const LOGO_LEFT = [
  `   _____ _               _   `,
  `  / ____| |             | |  `,
  ` | |  __| |__   ___  ___| |_ `,
  ` | | |_ | '_ \\ / _ \\/ __| __|`,
  ` | |__| | | | | (_) \\__ \\ |_ `,
  `  \\_____|_| |_|\\___/|___/\\__|`,
]

const LOGO_RIGHT = [
  `  _____ _          _ _ `,
  ` / ____| |        | | |`,
  `| (___ | |__   ___| | |`,
  ` \\___ \\| '_ \\ / _ \\ | |`,
  ` ____) | | | |  __/ | |`,
  `|_____/|_| |_|\\___|_|_|`,
]

export function Logo() {
  const { theme } = useTheme()
  return (
    <box>
      <For each={LOGO_LEFT}>
        {(line, index) => (
          <box flexDirection="row" gap={1}>
            <text fg={theme.textMuted} selectable={false}>
              {line}
            </text>
            <text fg={theme.text} attributes={TextAttributes.BOLD} selectable={false}>
              {LOGO_RIGHT[index()]}
            </text>
          </box>
        )}
      </For>
    </box>
  )
}
