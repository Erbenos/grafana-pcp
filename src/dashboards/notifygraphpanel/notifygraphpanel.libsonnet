{
  panel: {
    new(
      title,
      datasource,
      meta,
      threshold=null,
      bars=false,
      lines=true,
      line_width=1,
      points=false,
      stack=false,
      null_value='null',
      is_legend_visible=true,
      display_mode='list',
      placement='under',
      time_from=null,
      time_shift=null,
    )::{
      title: title,
      type: 'pcp-notifygraph-panel',
      datasource: datasource,
      options: {
        graph: {
            showBars: bars,
            showLines: lines,
            lineWidth: line_width,
            showPoints: points,
            isStacked: stack,
            nullValue: null_value
        },
        legend: {
            isLegendVisible: is_legend_visible,
            displayMode: display_mode,
            placement: placement
        },
        [if threshold != null then 'threshold']: threshold,
        meta: meta,
      },
      timeFrom: time_from,
      timeShift: time_shift,
      _nextTarget:: 0,
      addTarget(target):: self {
        local nextTarget = super._nextTarget,
        _nextTarget: nextTarget + 1,
        targets+: [
            {
                expr: target.expr,
                format: target.format,
                [if std.objectHas(target, 'name') then 'name']: target.name,
                refId: std.char(std.codepoint('A') + nextTarget)
            }],
      },
      addTargets(targets):: std.foldl(function(p, t) p.addTarget(t), targets, self),
    },
  },
  metric: {
    new(
      name,
      title='',
    )::{
      name: name,
      [if title != '' then 'title']: title,
    },
  },
  threshold: {
    new(
      metric,
      operator,
      value,
    )::{
      metric: metric,
      operator: operator,
      value: value,
    },
  },
  meta: {
    new(
      name,
      warning='',
      metrics=[],
      derived=[],
      urls=[],
      issues=[],
      details='',
      children=[],
      parents=[],
    )::{
      name: name,
      [if warning != '' then 'warning']: warning,
      metrics: metrics,
      derived: derived,
      urls: urls,
      issues: issues,
      [if details != '' then 'details']: details,
      children: children,
      parents: parents,
    },
  },
}
