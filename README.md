# Sensu::Extensions::Occurrences

This filter extension provides the Sensu Core built-in filter
`occurrences`.

This filter provides the functionality that will soon be removed from
the sensu-plugin handler library. Cameron Johnston wrote a great blog
post on this topic, [Deprecating Event Filtering in
sensu-plugin](https://blog.sensu.io/deprecating-event-filtering-in-sensu-plugin-b60c7c500be3).

The `occurrences` filter will determine if an event occurrence count
meets the user defined requirements in the event check definition.
Users can specify a minimum number of `occurrences` before an event
will be passed to a handler. Users can also specify a `refresh` time,
in seconds, to reset where recurrences are counted from.

[![Build Status](https://travis-ci.org/sensu-extensions/sensu-extensions-occurrences.svg?branch=master)](https://travis-ci.org/sensu/sensu-extensions-occurrences)

## Configuration

The `occurrences` filter is included in every install of Sensu. To
apply the filter to handler, use the `"filter"` or `"filters"` handler
definition attribute.

For example:

``` json
{
  "handlers": {
    "email": {
      "...": "...",
      "filter": "occurrences"
    }
  }
}
```

or

``` json
{
  "handlers": {
    "email": {
      "...": "...",
      "filters": ["occurrences"]
    }
  }
}
```

The `occurrences` filter uses two custom check definition attributes,
`occurrences`, and `refresh`.

`occurrences`: The number of event occurrences that must occur before
an event is handled for the check (default is `1`).

`refresh`: Time in seconds until the event occurrence count is
considered reset for the purpose of counting occurrences, to allow an
event for the check to be handled again (default is `1800`). For
example, a check with a `refresh` of 1800 will have its events
(recurrences) handled every 30 minutes, to remind users of the issue.

For example:

``` json
{
  "checks": {
    "check-http": {
      "...": "...",
      "occurrences": 2,
      "refresh": 3600
    }
  }
}
```
