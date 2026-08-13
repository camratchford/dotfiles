from pathlib import Path

from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, TabAccessor, ColorFormatter, draw_attributed_string


def draw_title(draw_data: DrawData, screen: Screen, tab: TabBarData, index: int, max_title_length: int = 0) -> None:
    tab_accessor = TabAccessor(tab.tab_id)
    data = {
        'index': index,
        'layout_name': tab.layout_name,
        'num_windows': tab.num_windows,
        'num_window_groups': tab.num_window_groups,
        'title': tab.title,
        'tab': tab_accessor,
    }
    ColorFormatter.draw_data = draw_data
    ColorFormatter.tab_data = tab
    title = f"{[index]} {Path.cwd().name}"
    draw_attributed_string(title, screen)
