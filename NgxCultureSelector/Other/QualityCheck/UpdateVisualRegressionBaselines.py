from ScriptCollection.TFCPS.NodeJS.TFCPS_CodeUnitSpecific_NodeJS import TFCPS_CodeUnitSpecific_NodeJS_Functions,TFCPS_CodeUnitSpecific_NodeJS_CLI
from ScriptCollection.TFCPS.TFCPS_VisualRegressionTests import TFCPS_VisualRegressionTests
import glob
import os
from PIL import Image


def update_readme_picture(tf:TFCPS_CodeUnitSpecific_NodeJS_Functions):
    """
    Updates the picture in the readme by taking the first available baseline screenshot,
    cropping it to show only the component, and saving it to the readme image location.
    """
    # Path where the readme image should be saved
    readme_image_path = os.path.join(tf.get_repository_folder(), "Other", "Reference", "Technical", "Images", "CultureSelector.png")
    
    # Find the first available baseline screenshot: try open first, then closed
    baseline_dir = os.path.join(tf.get_codeunit_folder(), "Other", "Resources", "VisualRegressionBaselines")
    
    matches = glob.glob(os.path.join(baseline_dir, "*", "*", "culture-selector-open.png"))
    if matches:
        source_image_path = matches[0]
    else:
        matches = glob.glob(os.path.join(baseline_dir, "*", "*", "culture-selector-closed.png"))
        if matches:
            source_image_path = matches[0]
        else:
            raise FileNotFoundError("No baseline screenshot found for culture-selector")
    
    # Open the source image
    with Image.open(source_image_path) as img:
        # Crop to the component area - for culture-selector, we take the center area
        # The viewport is 800x400, and the component is roughly in the center
        width, height = img.size
        
        # Calculate crop box: remove top and bottom margins to focus on the component
        # Based on the demo page layout, we crop from y=100 to y=300
        left = 0
        top = 100
        right = width
        bottom = 300
        
        # Ensure crop box is within image bounds
        left = max(0, left)
        top = max(0, top)
        right = min(width, right)
        bottom = min(height, bottom)
        
        cropped_img = img.crop((left, top, right, bottom))
        
        # Ensure the output directory exists
        os.makedirs(os.path.dirname(readme_image_path), exist_ok=True)
        
        # Save the cropped image
        cropped_img.save(readme_image_path, "PNG")
        print(f"Updated readme picture: {readme_image_path}")


def update_visual_regression_baselines():
    tf:TFCPS_CodeUnitSpecific_NodeJS_Functions=TFCPS_CodeUnitSpecific_NodeJS_CLI.parse(__file__)
    TFCPS_VisualRegressionTests(tf).run(True)
    update_readme_picture(tf)


if __name__ == "__main__":
    update_visual_regression_baselines()
