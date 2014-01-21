# Views transition

```dot
diagraph sample {
    A [label = "index.html"];
    B [label = "show.html"];
    C [label = "new.html"];

    A -> B [dir = both];
    A -> C;
    C -> A [label = "redirect"];
}
```

- Users can visit show.html from index.html.
- Users can visit index.html from show.html.
- Users can visit new.html from index.html.
- Users can redirect to index.html from new.html.
