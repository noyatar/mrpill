#!/bin/bash

# סקריפט מעודכן להורדת תמונות כל המוצרים
cd "$(dirname "$0")/../products" || exit

# מיפוי מוצרים - שם עברי -> URL באתר
declare -A products
products["מקלילון-לרציניים"]="מקלילון-מתנה-לרציניים-ליום-הולדת-לחבר/"
products["מנחוסון-למנחוסים"]="manhuson/"
products["נובטמין-לגיימרים"]="מתנה-לגיימר-נובּוטמין-קופסת-מתנה-לגיי/"
products["ביישנול-לביישניים"]="מתנה-לביישנית-ביישנול-קופסת-מתנה-לביי/"
products["סאחינול-לסאחי"]="סאחינול-מתנה-לסאחי/"
products["חרפן-לעייפים"]="חרפן-מתנה-לחבר-עייף/"
products["טיולין-למטיילים"]="טיולין-מתנה-למטייל-לטבע-לחבר-לחברה/"
products["חפרלין-לחופרים"]="חפרלין-מתנה-לחופר/"
products["פרפקטמול-לפרפקציוניסטים"]="פרפקטמול-מתנה-לפרפקציוניסט/"
products["דרמטין-לדרמטיות"]="דרמטין-מתנה-לחברה-דרמטית/"
products["מטומטמול-לטמבלולים"]="מטומטמול-קופסת-מתנה-לגבר-לטמבלול-לחבר/"
products["עצלנומצין-לעצלנים"]="מתנה-ליום-הולדת-עצלנומצין-קופסת-מתנה-ל/"
products["מירמורון-למרירים"]="מתנה-מצחיקה-מירמורון-קופסת-מתנה-למריר/"
products["צחלטין-לצוחקניות"]="מתנה-לחברה-הכי-טובה-צחלטין-קופסת-מתנה/"
products["הפתעה-איחורון-למאחרים"]="הפתעה-איחורון-קופסת-מתנה-למאחרים-מתנה/"
products["סטלנומי-לסטלנים"]="מתנה-לסטלן-סטלנומי-קופסת-מתנה-לסטלנים/"
products["גיוס-צהובון-לחיילים"]="מתנה-לגיוס-צהובון-מתנה-לחיילים-לשחרור/"
products["מאוהבון-לזוגות"]="מתנה-לשנה-ביחד-מאוהבון-לבת-לבן-זוג-לחבר/"
products["קמצנול-לקמצנים"]="קמצנול-מתנה-לקמצן-מצחיק-לחבר-לחברה-לחס/"
products["מצחיקול-למשפחה"]="מצחיקול-מתנה-לאבא-לאמא-למשפחה/"

echo "מתחיל הורדת תמונות לכל המוצרים..."

for product_name in "${!products[@]}"; do
    url_path="${products[$product_name]}"
    echo "מעבד: $product_name"
    
    if [ ! -d "$product_name/images" ]; then
        echo "תיקיה לא קיימת: $product_name"
        continue
    fi
    
    # חפש תמונות בדף המוצר
    product_url="https://mr-pill.com/product/$url_path"
    echo "טוען דף: $product_url"
    
    # הורד תמונות מהדף
    images=$(curl -s "$product_url" | grep -o 'https://mr-pill.com/wp-content/uploads/[^"]*\.\(jpg\|jpeg\|png\|webp\)' | head -5)
    
    if [ -z "$images" ]; then
        echo "⚠️  לא נמצאו תמונות עבור $product_name"
        continue
    fi
    
    counter=1
    while IFS= read -r image_url; do
        if [ -n "$image_url" ]; then
            extension="${image_url##*.}"
            filename="image-$counter.$extension"
            echo "   📥 מוריד: $filename"
            wget -O "$product_name/images/$filename" "$image_url" -q
            
            # שמור קישור גם כקובץ טקסט
            echo "$image_url" >> "$product_name/images/sources.txt"
            
            ((counter++))
        fi
    done <<< "$images"
    
    echo "✅ הושלם: $product_name ($((counter-1)) תמונות)"
done

echo "🎉 הסתיימה הורדת כל התמונות!"