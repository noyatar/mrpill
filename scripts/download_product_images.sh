#!/bin/bash

# סקריפט להורדת תמונות המוצרים
cd "$(dirname "$0")/../products" || exit

# רשימת מוצרים עם URL שמות באנגלית
declare -A products
products["מקלילון-לרציניים"]="maklillon"
products["נובטמין-לגיימרים"]="novatmin" 
products["מנחוסון-למנחוסים"]="manhuson"
products["סאחינול-לסאחי"]="sahinol"
products["טיולין-למטיילים"]="tiyulin"
products["ביישנול-לביישניים"]="biyshnol"
products["חרפן-לעייפים"]="harpan"
products["פרפקטמול-לפרפקציוניסטים"]="perfectmol"
products["חפרלין-לחופרים"]="hafrlin"
products["דרמטין-לדרמטיות"]="dermatin"
products["עצלנומצין-לעצלנים"]="azlanomycin"
products["הפתעה-איחורון-למאחרים"]="haftaa-ihuron"

echo "מתחיל הורדת תמונות..."

for product_name in "${!products[@]}"; do
    url_name="${products[$product_name]}"
    echo "מעבד מוצר: $product_name ($url_name)"
    
    if [ ! -d "$product_name/images" ]; then
        echo "תיקיית התמונות לא קיימת עבור $product_name"
        continue
    fi
    
    # חפש תמונות בדף המוצר
    product_url="https://mr-pill.com/product/$url_name/"
    images=$(curl -s "$product_url" | grep -o 'https://mr-pill.com/wp-content/uploads/[^"]*\.\(jpg\|jpeg\|png\|webp\)' | head -3)
    
    if [ -z "$images" ]; then
        echo "לא נמצאו תמונות עבור $product_name"
        continue
    fi
    
    counter=1
    while IFS= read -r image_url; do
        if [ -n "$image_url" ]; then
            extension="${image_url##*.}"
            filename="$url_name-$counter.$extension"
            echo "מוריד: $image_url -> $filename"
            wget -O "$product_name/images/$filename" "$image_url" -q
            ((counter++))
        fi
    done <<< "$images"
    
    echo "הושלמה הורדה עבור $product_name"
done

echo "הסתיימה הורדת התמונות"