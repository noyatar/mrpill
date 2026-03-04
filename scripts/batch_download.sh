#!/bin/bash

cd "$(dirname "$0")/../products" || exit

# מוצרים שנותר להוריד
declare -A remaining_products
remaining_products["ביישנול-לביישניים"]="מתנה-לביישנית-ביישנול-קופסת-מתנה-לביי/"
remaining_products["חרפן-לעייפים"]="חרפן-מתנה-לחבר-עייף/"
remaining_products["טיולין-למטיילים"]="טיולין-מתנה-למטייל-לטבע-לחבר-לחברה/"
remaining_products["חפרלין-לחופרים"]="חפרלין-מתנה-לחופר/"
remaining_products["פרפקטמול-לפרפקציוניסטים"]="פרפקטמול-מתנה-לפרפקציוניסט/"
remaining_products["דרמטין-לדרמטיות"]="דרמטין-מתנה-לחברה-דרמטית/"
remaining_products["מטומטמול-לטמבלולים"]="מטומטמול-קופסת-מתנה-לגבר-לטמבלול-לחבר/"
remaining_products["עצלנומצין-לעצלנים"]="מתנה-ליום-הולדת-עצלנומצין-קופסת-מתנה-ל/"

for product_name in "${!remaining_products[@]}"; do
    url_path="${remaining_products[$product_name]}"
    echo "מוריד תמונות ל: $product_name"
    
    urls=$(curl -s "https://mr-pill.com/product/$url_path" | grep -o 'https://mr-pill.com/wp-content/uploads/[^"]*\.\(jpg\|jpeg\|png\|webp\)' | sort | uniq | head -4)
    
    counter=1
    while IFS= read -r url; do
        if [[ "$url" =~ \.(jpg|jpeg|png|webp)$ ]]; then
            extension="${url##*.}"
            # יצירת שם קובץ עם בסיס של שם המוצר
            base_name=$(echo "$product_name" | sed 's/-.*//' | sed 's/[^א-ת]//g')
            filename="$base_name-$counter.$extension"
            
            echo "  📥 $filename"
            wget -O "$product_name/images/$filename" "$url" -q
            ((counter++))
        fi
    done <<< "$urls"
    
    echo "✅ $product_name הושלם"
done

echo "🎉 הושלמה הורדת תמונות לכל המוצרים!"