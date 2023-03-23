import calendar

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import streamlit as st
from st_aggrid import AgGrid

# URL = "https://raw.githubusercontent.com/fivethirtyeight/data/master/airline-safety/airline-safety.csv"
URL = "https://raw.githubusercontent.com/apache-superset/examples-data/master/tutorial_flights.csv"


@st.cache_data(show_spinner=False)
def load_data():
    return (
        pd.read_csv(URL)
        .pipe(
            lambda _df: _df.rename(
                columns={ _: _.lower().replace(" ", "_") for _ in _df.columns },
            )
        )
        .assign(
            travel_date=lambda _df: pd.to_datetime(_df.travel_date),
            travel_class=lambda _df: _df.travel_class.astype(
                pd.CategoricalDtype([
                      "Economy", "Premium Economy", "Business","First",
                ], ordered=True)
            )
        )
    )


# plt.style.use("default")
sns.set_theme()
sns.set_context("talk")

description = """
This is a demo application that analyzes a freely available dataset of flight data from 2011.

Lorem ipsum dolor sit amit.
"""


def dt_month_to_categorical(series):
    return pd.Categorical.from_codes(series, list(calendar.month_abbr), ordered=True)


def dt_weekday_to_categorical(series):
    return pd.Categorical.from_codes(series, list(calendar.day_abbr), ordered=True)


df = load_data()
sns_flights_by_month = sns.displot(
    df,
    x=dt_month_to_categorical(df.travel_date.dt.month),
    hue="travel_class",
    multiple="dodge",
    discrete=True,
    shrink=.75,
    aspect=3,
).set_ylabels("")

sns_flights_by_weekday = sns.displot(
    df,
    x=dt_weekday_to_categorical(df.travel_date.dt.weekday),
    hue="travel_class",
    multiple="dodge",
    discrete=True,
    shrink=.75,
    aspect=3,
).set_ylabels("")

st.set_page_config(layout="wide")
col1, col2 = st.columns([1, 3])

with col1:
    st.title("Flight data analysis")
    st.markdown(description)


with col2:
    tab1, tab2 = st.tabs(["Flights by month", "Flights by weekday"])
    with tab1:
        st.pyplot(sns_flights_by_month)

    with tab2:
        st.pyplot(sns_flights_by_weekday)

st.dataframe(df, height=400)
