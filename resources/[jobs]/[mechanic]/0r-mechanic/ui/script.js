// ALL MADE BY Ayazwai
// Discord: Ayazwai#3900 
// Linkedin: https://www.linkedin.com/in/ayaz-ekrem-770305212/
// Instagram: https://www.instagram.com/ayaz.ekremm/
// Discord Server: https://discord.com/invite/YanMPNg8Zn
// If you use leak your server will be shut down with a copyright claim
// https://ayazwai.dev

$('body, .color-menu, .fitment-menu, .eye').hide();
// $('.color-menu, .fitment-menu, .eye').hide();
/////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES'S //
/////////////////////////////////////////////////////////////////////////////////////////

let colorPicker = new iro.ColorPicker('#picker', {
    width: 100,
    layoutDirection : 'vertical',
    borderColor: '#fff',
    borderWidth: 1,
    wheelDirection: 'clockwise',
    sliderSize: 10,
});

var itemimages = {
    "spoiler": [
        "spoiler",
        "spoiler0",
        "spoiler1",
    ],
    "suspension": [
        "suspension",
        "suspension1",
        "suspension2",
        "suspension3",
        "suspension4",
        "suspension5"
    ],
    "exhausts": [
        "exhausts",
        "exhausts1",
        "exhausts2",
        "exhausts3",
        "exhausts4",
        "exhausts5",
    ],
    "window_tint": [
        "window_tint",
        "window_tint1",
        "window_tint2",
        "window_tint3",
        "window_tint4",
    ],
    "brakes": [
        "brakes",
        "brakes1",
        "brakes2",
        "brakes3",
        "brakes4",

    ],
    "wheel": [
        "wheel",
        "wheel1",
        "wheel2",
        "wheel3",
        "wheel4",
    ],
    "frontbumper": [
        "front_bumper",
        "front_bumper0",
    ],
    "rearbumper": [
        "rear_bumper",
        "rear_bumper0",
    ],
    "grille": [
        "grille",
        "grille0",
    ],
    "horn": [
        "horn",
        "horn1",
    ]
};

var basket = []
var cursorStateOnControl = false

let selectedColor = undefined
let cooldown = false;
let mainMenus;
let subMenus; 
let altMenus;
let activeMenuName;
let activeIndex = 0;
let maxIndex = 0;
let firstIndex = 0;
let secondIndex = 0;
let selectedType
let selectedTypeSecond
let inColorMenu = false;
let inFitmentMenu = false;
let currentWheelIndex = null

let firstSelectorItems = [
    "Primary",
    "Secondary",
    "Chameleon",
    "Neon Color",
    "Smoke Color",
    "Wheel Color"
]

let secondSelectorItems = [
    "Classic",
    "Metallic",
    "Matte",
    "Metal",
    "Pearlescent", 
    "Chrome",
]

let colors
let metalcolors
let metallicColors
let chromeColors
let chameleoncolors 
let mattecolors 
let pearlescentColors 
let chameleonIndex = 0;
let rgba = false
let rgbColor = undefined

let wheels = {
    "wheels-width": 1,
    "front-left": 1,
    "front-right": 1,
    "rear-left": 1,
    "rear-right": 1,
}

let buyedComps
let prices 

/////////////////////////////////////////////////////////////////////////////////////////
// UI CONTROL'S //
/////////////////////////////////////////////////////////////////////////////////////////


AddToBasket = function(){

}


GetTotalPriceOfBasket = function(){
    var totalPrice = 0
    for (var k in basket) {
        let basketItem = basket[k].component
        // console.log(97, JSON.stringify(basketItem))
        totalPrice += basketItem.price
    }
    return totalPrice
}

document.onkeyup = function(data) {
    let key = data.key;
    // // console.log(key, 92)
    if (key == "Control") {
        $.post('https://0r-mechanic/cursorState', JSON.stringify({
            cursor: !cursorStateOnControl,
        }));
        cursorStateOnControl = !cursorStateOnControl
    }
    if (key == "ArrowRight") {
        $('.menu-item').attr('data-active', 'false');
        activeIndex++;
        if (activeIndex == maxIndex) {
            activeIndex = 0;
            $('.menu-items').animate({ scrollLeft: 0 }, 200);
        } else if (activeIndex % 4 == 0) {
            let pageIndex = Math.floor(activeIndex / 4);
            let menuItemWidth = $('.menu-item').outerWidth();
            let scrollAmount = pageIndex * 4.12 * menuItemWidth;
            $('.menu-items').animate({ scrollLeft: scrollAmount }, 200);
        }
        $(`.menu-item[data-id="${activeIndex}"]`).attr('data-active', 'true');
    } else if (key == "ArrowLeft") {
        $('.menu-item').attr('data-active', 'false');
        activeIndex--;
        if (activeIndex < 0) {
            activeIndex = maxIndex - 1;
            let pageIndex = Math.floor(activeIndex / 4);
            let menuItemWidth = $('.menu-item').outerWidth();
            let scrollAmount = pageIndex * 4.12 * menuItemWidth;
            $('.menu-items').animate({ scrollLeft: scrollAmount }, 200);
        } else if ((activeIndex + 1) % 4 == 0) {
            let pageIndex = Math.floor(activeIndex / 4);
            let menuItemWidth = $('.menu-item').outerWidth();
            let scrollAmount = pageIndex * 4.12 * menuItemWidth;
            $('.menu-items').animate({ scrollLeft: scrollAmount }, 200);
        }
        $(`.menu-item[data-id="${activeIndex}"]`).attr('data-active', 'true');
    } else if (key == "Enter") {
        let selected = $(`.menu-item[data-id="${activeIndex}"]`).data('type');
        let selectedId = $(`.menu-item[data-id="${activeIndex}"]`).data('id');

        if (selected == "main") {
            if (mainMenus[selectedId].label == "Paint Booth") {
                openPaintMenu()
                $.post('https://0r-mechanic/cursorState', JSON.stringify({
                    cursor: true,
                }));
            }else if (mainMenus[selectedId].label == "Wheel Fitment") {
                $.post('https://0r-mechanic/getWheelFitment', JSON.stringify({}), function(fitmentData){
                    wheels = fitmentData;
                    openFitment()
                });
                $.post('https://0r-mechanic/cursorState', JSON.stringify({
                    cursor: true,
                }));
            }else if (mainMenus[selectedId].label == "Repair Vehicle") {
                $.post('https://0r-mechanic/repairVehicle', JSON.stringify({}));
            }else {
                buildMenu("submenu", selectedId, null);
            }
            $(".category-name").html(mainMenus[selectedId].label)
        }else if (selected == "submenu") {
            let mainId = $(`.menu-item[data-id="${activeIndex}"]`).data('mainid');
            let component = $(`.menu-item[data-id="${activeIndex}"]`).data('componentname');
            buildMenu("altmenu", mainId, component);
            $('.menu-items').animate({ scrollLeft: 0 }, 200);
            $(".category-name").html(component)

        }else if (selected == "altmenu") {
            let item = $(`.menu-item[data-id="${activeIndex}"]`);
            // console.log(JSON.stringify(item))
            let img = $(`.menu-item[data-id="${activeIndex}"]`).find(".menu-item-image-content").find("img").attr("src");
            let itemData = item.data("itemtable")
            let attached = item[0].dataset.attached
            if (attached == "true" && itemData.modId == "extra" || attached === "false" || !attached) {
                for (var k in basket) {
                    if (basket[k].component.modId == item.data("itemtable").modId) {
                        delete basket[k]
                        $(".basket-item").each(function() {
                            var modId = $(this).data("modid");
                            var mod = $(this).data("mod");
                            if (modId && modId != "neon" && mod != item.data("itemtable").mod) {
                                if (modId == item.data("itemtable").modId) {
                                    $(this).remove();
                                }
                            }
                        });
                        break
                    }
                }
                if (basket.length < 1) {
                    $(".basket-main-content").empty()
                }
                basket.push({
                    component: item.data("itemtable")
                })
                var basketItem = `
                <div class="basket-item" data-modid="${item.data("itemtable").modId}" data-mod="${item.data("itemtable").mod}">
                <div class="category-blur"></div>
                <div class="basket-left-content">
                    <img src="${img}" alt="">
                    <div class="basket-item-info">
                        <h1>Part <span>#${item.data("itemtable").mod}</span></h1>
                        <p>${item.data("itemtable").label}</p>
                    </div>
                </div>
               
                <div class="delete-item-on-basket">
                    <img src="img/delete.svg" alt="">
                </div>
            </div>
                `
                $(".basket-main-content").prepend(basketItem)
                $(".total-price-info").html(`<span>$</span><div class="price-is">${GetTotalPriceOfBasket()}</div>`)
                // console.log("main wheel", $(`.menu-item[data-id="${activeIndex}"]`).data('wheel'))
                $.post('https://0r-mechanic/addShopItem', JSON.stringify({
                    modId : item.data("itemtable").modId,
                    mod : item.data("itemtable").mod,
                    main: $(`.menu-item[data-id="${activeIndex}"]`).data('wheel') || null
                }), function(buyed){
                    if (buyed) {
                        // // console.log("added buy")
                        mainMenus = buyed;
                        $('.menu-item').attr('data-attached', 'false');
                        item.attr('data-attached', 'true');
                        // let attachedMain = $('#attached').parent();
                        // if (item.data("componentname") != "Neon") {
                        //     $('#attached').remove();
                        // }
                        // attachedMain.html(`<span>$${attachedMain.data('price')}</span>`);
                        // let priceItem = item.children('.menu-item-price');
                        // priceItem.html('<i id="attached" class="fa-solid fa-circle-check"></i>')
                    }else {
                        item.attr('data-flash', 'true');
                        setTimeout(() => {
                            item.attr('data-flash', 'false');
                        }, 1000);
                    }
                });
            }
        }
    }else if (key == "Backspace") {
        if (inColorMenu) {
            closePaintMenu()
            $(".category-name").html("Main Menu")
            return
        }else if (inFitmentMenu) {
            $(".category-name").html("Main Menu")
            closeFitment()
            
        }else {
            let selected = $(`.menu-item[data-id="${activeIndex}"]`).data('type');

            if (selected === "altmenu") {
                $('.eye').fadeOut(250);
                let mainId = $(`.menu-item[data-id="${activeIndex}"]`).data('mainid');
                buildMenu("submenu", mainId, null);
                $('.menu-items').animate({ scrollLeft: 0 }, 200);
            }else if (selected === "submenu") {
                buildMenu("main", null, null);
            }else if (selected === "main") {
                $.post('https://0r-mechanic/close', JSON.stringify({}));
                $(".basket-main-content").empty()
                $(".total-price-info").html(`<span>$</span><div class="price-is">0</div>`)
                $(".basket-main-content").html(`
                                   <div class="empty-basket-text">
                    <h1>The basket is</h1>
                    <p>Empty!</p>
               </div>`)
                basket = []
            }else if (selected === undefined) {
                buildMenu("main", null, null);
            }
        }
    }

    if (key == "Backspace" || key == "Enter" || key == "ArrowLeft" || key == "ArrowRight") {
        let item = $(`.menu-item[data-id="${activeIndex}"]`).data('itemtable');
        $.post('https://0r-mechanic/surfItem', JSON.stringify({
            clear: activeMenuName == "altmenu" ? false : true,
            mod: activeMenuName == "altmenu" ? item.mod : null,
            modId: activeMenuName == "altmenu" ? item.modId : null,
            wheelType: activeMenuName == "submenu" ? $(`.menu-item[data-id="${activeIndex}"]`).data('wheel') : null,
        }));
    }
};


$(document).on("click", ".delete-item-on-basket", function(){
    let closestBasketitem = $(this).closest(".basket-item")
    let modId = closestBasketitem.data("modid")
    let mod = closestBasketitem.data("mod")
    let wheelType = closestBasketitem.data("wheel") || null
    closestBasketitem.remove()
    $.post('https://0r-mechanic/deleteShopItem', JSON.stringify({
        mod: mod,
        modId: modId,
        wheelType: wheelType,
    }));
    for (var k in basket) {
        if (basket[k].component.modId == modId) {
            delete basket[k]
            break
        }
    }
    $(".total-price-info").html(`<span>$</span><div class="price-is">${GetTotalPriceOfBasket()}</div>`)
})

$(document).on("click", ".payment-button", function(){
    let type = $(this).attr("id")
    // // console.log(277, type)
    $.post("https://0r-mechanic/buyBasket", JSON.stringify({
        type: type,
        basketdata : basket
    }), function(t){
        if (t) {
            basket = []
            $(".basket-main-content").empty()
            $.post('https://0r-mechanic/close', JSON.stringify({
                type: true
            }));
        } else {
            // // console.log("no enough money")
        }
    })
})

$('body').mousemove(function() { 
    if (activeMenuName == "altmenu") {
        $.post('https://0r-mechanic/disableCamera', JSON.stringify({}));
    }
});

colorPicker.on('color:change', function(color) {
    $.post('https://0r-mechanic/changeColor', JSON.stringify({
        type: {
            first: selectedType == undefined ? "Primary" : selectedType,
            second: null,
        },
        picker: true,
        color: color.rgba
    }));
    rgba = true
    rgbColor = color.rgb
});

/////////////////////////////////////////////////////////////////////////////////////////
// MAIN BUILD UI FUNCTION'S //
/////////////////////////////////////////////////////////////////////////////////////////
const scrollSecondary = document.querySelector(".color-wheel[data-wheel='secondary']");

const formatNumber = (num) => {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, `.`);
}    

const buildMenu = (menu, objectId, component) => {
    $('.menu-items').html('');
    maxIndex = 0;
    activeIndex = 0;
    
    if (menu === "main") {
        Object.keys(mainMenus).forEach((menu) => {
            let menuContent = mainMenus[menu];

            let item = `
            <div class="menu-item category-one" data-id="${menu}" data-active="${menu == 0 ? "true" : "false"}" data-type="${menuContent.type}" data-componentname="none">
            <div class="menu-background">
               
            </div>
            <div class="category-header">
                <h1>${menuContent.label}</h1>
                <p>Personalized vehicles, boundles creativity</p>
            </div>
            <img src="img/${menuContent.img}.png">
            <div class="bottom-selection-text">
                <div class="text-selection">Open <span>Selection</span></div>
                <img src="img/arrow-right.svg" alt="">
            </div>
        </div>`
            // let item = `
            //     <div class="menu-item" data-id="${menu}" data-active="${menu == 0 ? "true" : "false"}" data-type="${menuContent.type}" data-componentname="none">
            //         <img src="img/${menuContent.img}.png">
            //         <span>${menuContent.label}</span>
            //     </div>
            // `;
            $('.menu-items').append(item);
            maxIndex++;
        });
        activeMenuName = "main";
    }else if (menu === "submenu") {
        let i = 0;
        let menuItems = [];
        Object.keys(mainMenus[objectId].items).forEach((subItem) => {
            let item = mainMenus[objectId].items[subItem];
            if (item.items == null || item.items == undefined) {
                return;
            };
            menuItems.push({
                label: subItem,
                item,
            });
        });
        
        menuItems.sort((a, b) => a.label.localeCompare(b.label));
        menuItems.forEach((menuItemObj, index) => {
            // console.log(392, menuItemObj.item.wheelType)
            let imgStyle = menuItemObj.item.img.includes("suspension") ? "style='height: 11vh; width: 7.5vh;'" : "";
            let menuItem = 
            `
            <div class="menu-item category-one" data-id="${index}" data-mainid="${objectId}" data-active="${index == 0 ? "true" : "false"}" data-type="${menuItemObj.item.type}" data-componentname="${menuItemObj.label}" data-wheel="${menuItemObj.item.wheelType != null || menuItemObj.item.wheelType != undefined ? menuItemObj.item.wheelType : "none"}">

            <div class="category-header">
                <h1>${menuItemObj.label}</h1>
                <p>Personalized vehicles, boundles creativity</p>
            </div>
            <img ${imgStyle} src="img/${menuItemObj.item.img}.png">
            <div class="bottom-selection-text">
                <div class="text-selection">Open <span>Selection</span></div>
                <img src="img/arrow-right.svg" alt="">
            </div>
        </div>`
        
            maxIndex++;
            $('.menu-items').append(menuItem);
        });
        activeMenuName = "submenu";
    }else if (menu === "altmenu") {
        let i = 0;
        $('#eye-label').html(component)
        $.each(mainMenus[objectId].items[component].eyepos, function (i, v) { 
            $('.eye').css({
                [i]: `${v}vh`
            })
        });
        Object.keys(mainMenus[objectId].items[component].items).forEach((altItem) => {
            // // console.log(385,objectId, altItem)
            let item = mainMenus[objectId].items[component].items[altItem];
            let itemTableString = JSON.stringify(item).replace(/"/g, "&quot;");
        
            // Check if component exists in itemimages
            // console.log("adasdsa", component)
            if (itemimages.hasOwnProperty(component.toLowerCase().replace(/\s/g, ''))) {

            let imagesArray = itemimages[component.toLowerCase().replace(/\s/g, '')];
            // rest of the code
                // Check if imagesArray is an array
                if (Array.isArray(imagesArray)) {
                    let randomIndex = Math.floor(Math.random() * imagesArray.length);
            
                    // Check if the index is within the array length
                    if (randomIndex < imagesArray.length) {
                        // Check if the object exists, if not create it
                        if (!mainMenus[objectId].items[component.toLowerCase()]) {
                            mainMenus[objectId].items[component.toLowerCase()] = {};
                        }
            
                        // Replace the img attribute with a random image from itemimages
                        // console.log(imagesArray[randomIndex])
                        mainMenus[objectId].items[component].img = imagesArray[randomIndex];
                    } else {
                        // console.log('Index out of range');
                    }
                } else {
                    // console.log('imagesArray is not an array');
                }
            }
            let imgStyle = mainMenus[objectId].items[component].img.includes("suspension") ? "style='height: 11vh; width: 7.5vh;'" : "";

            let menuItem = `
            <div class="menu-item" style="justify-content: flex-start;"data-id="${i}" data-mainid="${objectId}" data-active="${i == 0 ? "true" : "false"}" data-type="altmenu" data-componentname="${component}" data-itemtable="${itemTableString}" data-flash="false" data-attached=${item.attached != undefined || item.attached != null ? item.attached  : "false"}>
            <div class="menu-background">
            </div>
            <div class="menu-item-info">
                <h1>PART <span>#${i}</span></h1>
                <p>$${item.label}</p>
            </div>
    <div class="menu-item-image-content">
        <img ${imgStyle} src="img/${item.img || mainMenus[objectId].items[component].img}.png">
    </div>
            <div class="alt-content">
                <div class="alt-content-row">
                    <div class="stock-situation">
                        <span>in</span> STOCK
                    </div>
                    <div class="menu-item-price">
                        <span>$</span>${item.price}
                    </div>
                </div>
            </div>
            </div>`
            maxIndex++;
            i++;
            $('.menu-items').append(menuItem);
        });
        setTimeout(() => {
            $('.eye').fadeIn(250);
        }, 1250);
        activeMenuName = "altmenu";
    }

    $.post('https://0r-mechanic/rotateCamera', JSON.stringify({
        menu: activeMenuName,
        objectId: objectId,
        component: component
    }));
}

// const buildColors = (type, selected, firstOpen) => {
//     if 
// }


function hexToRgba(hex, alpha) {
    let r = 0, g = 0, b = 0;
    if (hex.length == 4) {
        r = parseInt(hex[1] + hex[1], 16);
        g = parseInt(hex[2] + hex[2], 16);
        b = parseInt(hex[3] + hex[3], 16);
    } else if (hex.length == 7) {
        r = parseInt(hex[1] + hex[2], 16);
        g = parseInt(hex[3] + hex[4], 16);
        b = parseInt(hex[5] + hex[6], 16);
    }
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}


function hexToRgba(hex, alpha) {
    let r = 0, g = 0, b = 0;
    if (hex.length === 4) {
        r = parseInt(hex[1] + hex[1], 16);
        g = parseInt(hex[2] + hex[2], 16);
        b = parseInt(hex[3] + hex[3], 16);
    } else if (hex.length === 7) {
        r = parseInt(hex[1] + hex[2], 16);
        g = parseInt(hex[3] + hex[4], 16);
        b = parseInt(hex[5] + hex[6], 16);
    }
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}

function componentToHex(c) {
    let hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

function rgbaToHex(rgba) {
    let result = rgba.match(/\d+/g);
    if (result) {
        let r = parseInt(result[0]);
        let g = parseInt(result[1]);
        let b = parseInt(result[2]);
        return rgbToHex(r, g, b);
    }
    return null;
}

$(document).on("click", ".category-one", function(){
    let attrId = $(this).attr("id")
    if (attrId == "fitment") {
        openFitment();
    } else if (attrId == "customization") {
        buildMenu("main", null, null);
    }
})



// const buildColors = (type, selected, firstOpen) => {
//     // $(".color-menu").fadeIn(500)
//     $(".default-colors").fadeIn(500)
//     if (!firstOpen) {
//         if (type == "secondary") {
//             let price = selected == "Metallic" || selected == "Classic" || selected == "Matte" || selected == "Metal" ? prices.color : selected == "Pearlescent" ? prices.pearlescent : selected == "Chrome" ? prices.chrome  : prices.color;
//             let arr = selected == "Classic" ? colors : selected == "Metallic" ? metallicColors : selected == "Matte" ? mattecolors : selected == "Metal" ? metalcolors : selected == "Pearlescent" ? pearlescentColors : selected == "Chrome" ? chromeColors : colors;
//             $(`.default-colors[data-wheel="${type}"]`).html('');
//             $.each(arr, function (i, v) { 
//                 if (v.hex == undefined) return;
//                 const borderColor = hexToRgba(v.hex, 0.5);


//             let div = `
//                 <div class="color" 
//                      style="background: ${v.hex}; 
//                             border: 3px solid ${borderColor};" 
//                      data-colorindex="${v.colorindex}">
//                 </div>
//             `;
            
//                 $(`.default-colors[data-wheel="${type}"]`).append(div);
//             });
//             $('#buyButton').html(`Buy Color $${formatNumber(price)}`);
//         }else if (type == "main") {
//             let price = selected == "Chameleon" ? prices.chameleon : selected == "Neon Color" ? prices.neon : selected == "Smoke Color" ? prices.smoke : prices.color;
//             if (selected == "Chameleon") {
//                 $('#chameleon').html(chameleoncolors[0].name);
//             }
//             $('#buyButton').html(`Buy Color $${formatNumber(price)}`);
//         }
//     }else {
//         $('.default-colors[data-wheel="secondary"]').html('');
//         $.each(colors, function (i, v) { 
//             if (v.hex == undefined) return;
//             const borderColor = hexToRgba(v.hex, 0.5);
//             // // console.log(borderColor);
//             let div = `
//                 <div class="color" 
//                      style="background: ${v.hex}; 
//                             border: 3px solid ${borderColor};" 
//                      data-colorindex="${v.colorindex}">
//                 </div>
//             `;
            
//             $(`.default-colors[data-wheel="secondary"]`).append(div);
//         });
//         $('#buyButton').html(`Buy Color $${formatNumber(prices.color)}`);
//     }
// }

const buildColors = (type, selected, firstOpen) => {
    if (!firstOpen) {
        if (type == "secondary") {
            let price = selected == "Metallic" || selected == "Classic" || selected == "Matte" || selected == "Metal" ? prices.color : selected == "Pearlescent" ? prices.pearlescent : selected == "Chrome" ? prices.chrome  : prices.color;
            let arr = selected == "Classic" ? colors : selected == "Metallic" ? metallicColors : selected == "Matte" ? mattecolors : selected == "Metal" ? metalcolors : selected == "Pearlescent" ? pearlescentColors : selected == "Chrome" ? chromeColors : colors;
            $(`.color-wheel[data-wheel="${type}"]`).html('');
            $.each(arr, function (i, v) { 
                if (v.hex == undefined) return;
                let div = `
                    <div class="color" style="background: ${v.hex};" data-colorindex="${v.colorindex}"></div>
                `
                $(`.color-wheel[data-wheel="${type}"]`).append(div);
            });
            $('#buyButton').html(`Buy Color $${formatNumber(price)}`);
        }else if (type == "main") {
            let price = selected == "Chameleon" ? prices.chameleon : selected == "Neon Color" ? prices.neon : selected == "Smoke Color" ? prices.smoke : prices.color;
            if (selected == "Chameleon") {
                $('#chameleon').html(chameleoncolors[0].name);
            }
            $('#buyButton').html(`Buy Color $${formatNumber(price)}`);
        }
    }else {
        $('.color-wheel[data-wheel="secondary"]').html('');
        $.each(colors, function (i, v) { 
            if (v.hex == undefined) return;
            let div = `
                <div class="color" style="background: ${v.hex};" data-colorindex="${v.colorindex}"></div>
            `
            $(`.color-wheel[data-wheel="secondary"]`).append(div);
        });
        $('#buyButton').html(`Buy Color $${formatNumber(prices.color)}`);
    }
}


function openPaintMenu() {
    inColorMenu = true;
    // $('.main-menu').fadeOut(250);
    $.post("https://0r-mechanic/colorState", JSON.stringify({}))
    $("#top-line").fadeOut(500, function(){
        $(".right-line").fadeIn(500)
        $(".left-line").fadeIn(500)
    })
    setTimeout(() => {
        $(".default-colors").fadeIn(500)
        buildColors(null, null, true);
        $('.color-menu').fadeIn(250);
    }, 250);
}


function closePaintMenu() {
    $.post('https://0r-mechanic/cursorState', JSON.stringify({
        cursor: false,
        type: "color"
    }));
    $("#top-line").fadeIn(500, function(){
        $(".right-line").fadeOut(500)
        $(".left-line").fadeOut(500)
    })
    $('.color-menu').fadeOut(250);
    setTimeout(() => {
        // $('.main-menu').fadeIn(250);
        setTimeout(() => {
            inColorMenu = false;
            chameleonIndex = 0;
            firstIndex = 0;
            secondIndex = 0;
            selectedType = undefined
            rgba = false
            rgbColor = undefined
            // $('div[data-id="openable"]').hide();
            // $('div[data-id="closeable"').show()
             $(".default-colors").fadeOut(500)
            $(`#main`).html(firstSelectorItems[0]);
            $(`#secondary`).html(secondSelectorItems[0]);
            $(`#chameleon`).html(chameleoncolors[0].name);
        }, 250);
    }, 250);
}

function openFitment() {
    $('.main-menu').fadeOut(250);
    inFitmentMenu = true;
    $.each(wheels, function (i, v) { 
        let span = $(`.fitment-modal[data-fitment="${i}"]`).children('#fitment');
        span.html(v.toFixed(2));
    });
    $('.fitment-menu').fadeIn(250);
}

function closeFitment() {
    $.post('https://0r-mechanic/cursorState', JSON.stringify({
        cursor: false,
    }));
    inFitmentMenu = false;
    $('.fitment-menu').fadeOut(250, function(){
        $('.main-menu').fadeIn(250);
    });
}

// scrollSecondary.addEventListener("wheel", (evt) => {
//     evt.preventDefault();
//     scrollSecondary.scrollLeft += evt.deltaY;
// });

$(document).on('click', '#arrow', function(){
    if (!cooldown) {
        cooldown = true;
        let type = $(this).data('type');
        let side = $(this).data('side');

        if (type != "fitment") {
            if (side == "left") {
                if (type == "main") {
                    firstIndex = firstIndex - 1;
                    if (firstIndex < 0) {
                        firstIndex = 0;
                    }
                }else if (type == "secondary") {
                    secondIndex = secondIndex - 1;
                    if (secondIndex < 0) {
                        secondIndex = 0;
                    }
                }else if (type == "chameleon") {
                    chameleonIndex = chameleonIndex - 1;
                    if (chameleonIndex < 0) {
                        chameleonIndex = 0;
                    }
                }
            }else if (side == "right") {
                if (type == "main") {
                    firstIndex = firstIndex + 1;
                    if (firstIndex > firstSelectorItems.length - 1) {
                        firstIndex = firstSelectorItems.length - 1;
                    }
                }else if (type == "secondary") {
                    secondIndex = secondIndex + 1;
                    if (secondIndex > secondSelectorItems.length - 1) {
                        secondIndex = secondSelectorItems.length - 1;
                    }
                }else if (type == "chameleon") {
                    chameleonIndex = chameleonIndex + 1;
                    if (chameleonIndex > chameleoncolors.length - 1) {
                        chameleonIndex = chameleoncolors.length - 1;
                    }
                }
            }
            
            if (firstSelectorItems[firstIndex] == "Chameleon") {
                $('div[data-id="closeable"]').fadeOut(250)
                setTimeout(() => {
                    $('div[data-id="openable"]').show()
                }, 250);
            }else if (firstSelectorItems[firstIndex] == "Neon Color" || firstSelectorItems[firstIndex] == "Smoke Color") {
                $('div[data-id="closeable"], div[data-id="openable"]').hide()
                $('#picker[data-id="closeable"').show()

            }else if (firstSelectorItems[firstIndex] == "Wheel Color") {
                $('div[data-id="closeable"]').show()
                $('#picker, #blabla').hide();
            }else {
                $('div[data-id="openable"]').hide();
                $('div[data-id="closeable"]').fadeIn(250)
            }

            if (type == "chameleon") {
                selectedType = "Chameleon";
                $(`#${type}`).html(chameleoncolors[chameleonIndex].name);
                $.post('https://0r-mechanic/changeColor', JSON.stringify({
                    type: {
                        first: selectedType,
                        second: null
                    },
                    picker: false,
                    color: chameleoncolors[chameleonIndex].colorindex
                }));
            }else {
                if (type == "main") {
                    selectedType = firstSelectorItems[firstIndex];
                }else if (type == "secondary") {
                    selectedTypeSecond = secondSelectorItems[secondIndex];
                }
                
                $(`#${type}`).html(type == "main" ? firstSelectorItems[firstIndex] : secondSelectorItems[secondIndex]);
                buildColors(type, type == "main" ? firstSelectorItems[firstIndex] : secondSelectorItems[secondIndex], false);
            }
        }else {
            let fitment = $(this).parent();
            let fitmentName = fitment.data('fitment');

            if (side == "right") {
                wheels[fitmentName] = wheels[fitmentName] + 0.01;
                if (wheels[fitmentName] >= 1) {
                    wheels[fitmentName] = 1;
                }
            }else if (side == "left") {
                wheels[fitmentName] = wheels[fitmentName] - 0.01;
                if (wheels[fitmentName] <= -1.0) {
                    wheels[fitmentName] = -1.0;
                }
            }
            fitment.children('#fitment').html(wheels[fitmentName].toFixed(2));
            $.post('https://0r-mechanic/changeFitment', JSON.stringify({
                type: fitmentName,
                value: wheels[fitmentName]
            }));
        }
        cooldown = false
    }
});

$(document).on('click', '.color', function(){
    if (rgba) {
        rgba = false;
    }
    let type = $(this).parent().data('wheel');
    let colorIndex = $(this).data('colorindex');
    selectedColor = colorIndex
    if (type == "main") {
        selectedType = firstSelectorItems[firstIndex];
        $.post('https://0r-mechanic/changeColor', JSON.stringify({
            type: {
                first: selectedType,
                second: null
            },
            picker: false,
            color: colorIndex
        }));
    }else if (type == "secondary") {
        $.post('https://0r-mechanic/changeColor', JSON.stringify({
            type: {
                first: firstSelectorItems[firstIndex],
                second: secondSelectorItems[secondIndex]
            },
            picker: false,
            color: colorIndex
        }));
    }

});


// ARAÇ RENGİNİ SATIN ALDIĞINDA, CARTDA BULUNAN TÜM MODLAR KALKACAK.
// currentMods sadece renkli hali olacak
// Daha sonra tüm karttaki modlar tekrar eklenecek

$(document).on('click', '#buyColor', function(){
    if (!cooldown) {
        cooldown = true;
        
        $.post('https://0r-mechanic/buyColor', JSON.stringify({
            type: {
                first: firstSelectorItems[firstIndex],
                second: secondSelectorItems[secondIndex]
            },
            color: !rgba ? selectedColor : null,
            picker: rgba ? rgbColor : false
        }), function(done) {
            cooldown = false;
            if (done) {
                // buraya color basket entegresi
            }
        });
    }
})

$(document).on('click', '#buyFitment', function(){
    if (!cooldown) {
        cooldown = true;
        $.post('https://0r-mechanic/applyFitment', JSON.stringify({}), function() {
            cooldown = false;
        });
    }
})


function playSoundEffect(soundEffect)
{
    var audioPlayer = null;

    if(audioPlayer != null)
    {
        audioPlayer.pause();
    }

    audioPlayer = new Howl({src: ["./sounds/" + soundEffect + ".ogg"]});
    audioPlayer.volume(0.4);
    audioPlayer.play();
}

/////////////////////////////////////////////////////////////////////////////////////////
// LISTENER AND SECOND BUILD FUNCTION'S //
/////////////////////////////////////////////////////////////////////////////////////////

window.addEventListener('message', function (event) {
    let e = event.data;
    switch (e.type) {
        case "OPEN_MENU":
            mainMenus = e.modMenu;
            if (e.state) {
                $('body').fadeIn(250);
                $("#top-line").fadeIn(250)
                buildMenu("main", null, null);
            }else {
                $('.menu-items').animate({ scrollLeft: 0 }, 0);
                $('body').fadeOut(250);
            }
            break;
        case "COLORS":
            colors = e.colors.defaultColors;
            metallicColors = e.colors.metallicColors;
            metalcolors = e.colors.metalColors;
            mattecolors = e.colors.matteColors;
            pearlescentColors = e.colors.pearlescentColors;
            chromeColors = e.colors.chromeColors;
            chameleoncolors = e.colors.chameleonColors;
            break;
        case "SET_PRICES":
            prices = e.price;
            break;
        case "SOUND":
            playSoundEffect(e.sound);
            break;
        default: break;
    }
});   

