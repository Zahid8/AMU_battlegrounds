import tensorflow as tf
model = tf.keras.models.load_model('resnet_model_tumor.h5')
import streamlit as st
st.write("""
         # Automated Brain Tumor Prediction
         """
         )
st.write("This is an image classification web app to predict Brain Tumors")
file = st.file_uploader("Please upload an image file", type=["jpg", "png"])
import cv2
from PIL import Image, ImageOps
import numpy as np
def import_and_predict(image_data, model):
    
        size = (180,180)    
        image = ImageOps.fit(image_data, size, Image.ANTIALIAS)
        image = np.asarray(image)
        img = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        img_resize = (cv2.resize(img, dsize=(180, 180),    interpolation=cv2.INTER_CUBIC))/255.
        
        img_reshape = img_resize[np.newaxis,...]
    
        prediction = model.predict(img_reshape)
        
        return prediction
if file is None:
    st.text("Please upload an image file")
else:
    image = Image.open(file)
    st.image(image, use_column_width=True)
    prediction = import_and_predict(image, model)
    

    result = prediction.argmax()
    if result == 0:
        st.write("Probable Prediction : Glioma Tumor")
    elif result == 1:
        st.write("Probable Prediction : Meningioma Tumor")
    elif result == 2:
        st.write("Probable Prediction : No Tumor")
    else:
        st.write("Probable Prediction : Pituitary Tumor")

#['glioma_tumor' 'meningioma_tumor' 'no_tumor' 'pituitary_tumor']


    
    st.text("Prediction Probabilities - 0 : Glioma Tumor, 1 : Meningioma Tumor, 2 : No Tumor, 3 : Pituitary Tumor")
    st.write(prediction)
    
    
    
    
    
    
    
import streamlit as st
from htbuilder import HtmlElement, div, ul, li, br, hr, a, p, img, styles, classes, fonts
from htbuilder.units import percent, px
from htbuilder.funcs import rgba, rgb


def image(src_as_string, **style):
    return img(src=src_as_string, style=styles(**style))


def link(link, text, **style):
    return a(_href=link, _target="_blank", style=styles(**style))(text)


def layout(*args):

    style = """
    <style>
      # MainMenu {visibility: hidden;}
      footer {visibility: hidden;}
     .stApp { bottom: 105px; }
    </style>
    """

    style_div = styles(
        position="fixed",
        left=0,
        bottom=0,
        margin=px(0, 0, 0, 0),
        width=percent(100),
        color="black",
        text_align="center",
        height="auto",
        opacity=1
    )

    style_hr = styles(
        display="block",
        margin=px(8, 8, "auto", "auto"),
        border_style="inset",
        border_width=px(2)
    )

    body = p()
    foot = div(
        style=style_div
    )(
        hr(
            style=style_hr
        ),
        body
    )

    st.markdown(style, unsafe_allow_html=True)

    for arg in args:
        if isinstance(arg, str):
            body(arg)

        elif isinstance(arg, HtmlElement):
            body(arg)

    st.markdown(str(foot), unsafe_allow_html=True)


def footer():
    myargs = [
        "Made by Protocol4 ",
    ]
    layout(*myargs)


if __name__ == "__main__":
    footer()
