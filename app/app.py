import streamlit as st
from st_aggrid import AgGrid
import pandas as pd

URL = 'https://raw.githubusercontent.com/fivethirtyeight/data/master/airline-safety/airline-safety.csv'

st.set_page_config(layout="wide")
st.title('Flight data analysis')

df = pd.read_csv(URL)
AgGrid(df, height=400)
