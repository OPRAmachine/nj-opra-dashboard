```{r}
fig <- plot_ly() 
fig <- fig %>% add_trace(
  type="choroplethmapbox",
  geojson=nj_counties,
  locations=counties$fips_code,
  z=counties$average_response_time,
  featureidkey="properties.FIPSSTCO",
  colorscale="Viridis",
  zmin=0,
  zmax=15,
  marker=list(line=list(
    width=0),
    opacity=0.5
  )
)
fig <- fig %>% layout(margin = list(b = 50, l = 50),
                      mapbox=list(
                        style="carto-positron",
                        zoom = 6,
                        center=list(lon= -74.558333, lat=40.07))
)
fig
```
