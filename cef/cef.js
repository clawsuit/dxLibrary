let cache = {};
//console.log('test principal')


function cefMemo(json){
    var value = JSON.parse(json)[0]
    const memo = document.createElement('textarea');

    memo.id = value.key;
    //memo.type = value.type;
    memo.placeholder = value.title;
    memo.innerHTML = value.text;
    // memo.cols = '20';
    // memo.rows = '2';
    // memo.cols = value.w+'';
    // memo.rows = value.h+'';
    memo.setAttribute( "spellcheck", String( false ) );
    //
    memo.style.position = 'absolute';
    memo.style.left = value.x + 'px';
    memo.style.top = value.y + 'px';
    memo.style.width = value.w+'px';
    memo.style.height = value.h+'px';
    // 
    if (value.background){
        memo.style.background = value.background;
    };
    if (value.colortext){
      memo.style.color = value.colortext;
    };
    memo.style.padding = '0';
    memo.style.margin = '0';
    memo.style.borderColor = 'transparent';
    // memo.style.textAlign = value.alignX;
    

    memo.oninput = () => {
        if (memo.escribir){
          mta.triggerEvent('onGeneralEvent', 'onChange', value.key, memo.value)
        }
    };

    if (value.rounded){
        memo.style['border-radius'] = value.rounded + 'px';
    }

    if (value.readonly){
      memo.setAttribute( "readonly", String( true ) );
    }

    if (value.parent){
        cache[value.parent].appendChild(memo)
    }else{
        document.getElementsByClassName('baseElement')[0].appendChild(memo)
    };

    cache[value.key] = memo;
}

function cefSetMemoState(json){
  var value = JSON.parse(json)[0];
  var memo = cache[value.key];

  if (value.type === 'focus'){
    memo.escribir = 'true';
    memo.focus()
  }else{
    memo.escribir = null;
    memo.blur()
  };
 // mta.triggerEvent('onGeneralEvent', 'evento', cache[value.key])
}


function cefSetProperty(json){
  var value = JSON.parse(json)[0];
  var element = cache[value.key];

  if (element){
    element[value.property] = value.value;
  }
}


function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    const shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, (m, r, g, b) => {
      return r + r + g + g + b + b;
    });
  
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result
      ? [
          parseInt(result[1], 16),
          parseInt(result[2], 16),
          parseInt(result[3], 16)
        ]
      : null;
  }
  
  function RGBToHSL(r, g, b){
      r /= 255;
      g /= 255;
      b /= 255;
      const l = Math.max(r, g, b);
      const s = l - Math.min(r, g, b);
      const h = s
        ? l === r
          ? (g - b) / s
          : l === g
          ? 2 + (b - r) / s
          : 4 + (r - g) / s
        : 0;
      return [
        60 * h < 0 ? 60 * h + 360 : 60 * h,
        100 * (s ? (l <= 0.5 ? s / (2 * l - s) : s / (2 - (2 * l - s))) : 0),
        (100 * (2 * l - s)) / 2,
      ];
    };












// function loadLItems(json){
//     LItems = JSON.parse(json)[0];
// }

// function insertItems(shop, json) {
//     var value = JSON.parse(json)[0]
//     if (value){
//         document.getElementById("titulo").innerHTML = shop;
//         //
//         const lista = document.getElementById('lista');
//         const rowCount = lista.rows.length;
//         //
//         for (var i = 0; i < rowCount; i++) {
//             lista.deleteRow(0)   
//         }

//         for (var i = 0; i < value.length; i++) {
//             //
//             let row = lista.insertRow(-1)
//             row.id = value[i].item; 
//             row.insertCell(0).innerHTML = LItems['' + value[i].item].name;
//             row.onclick = function(){
//                 //console.log(row.id);
//                 const row_old = document.getElementsByClassName('rowSelected')[0];
//                 if (row_old){
//                     row_old.style.backgroundColor = 'rgba(65, 65, 65, 0)';
//                     row_old.classList.remove('rowSelected');
//                 }
                
//                 row.style.backgroundColor = 'rgba(65, 65, 65, 0.7)';
//                 row.classList.add('rowSelected');

//                 document.getElementById('preview').innerHTML = LItems['' + row.id].name;
//                 // const img = document.getElementById('img');
//                 // console.log(img)
//                 // img.src = 'http://mta/gm_files/images/items/' + value[i].item + '.png';
//             };
//         }
//     }
// }

// function insertItems(shop, json) {
//     var value = JSON.parse(json)[0]
//     if (value) {
//         document.getElementById("titulo").innerHTML = shop;
//         //
//         const lista = document.getElementById('lista');
//         const rowCount = lista.rows.length;
//         //
//         for (var i = 0; i < rowCount; i++) {
//             lista.deleteRow(0)
//         }

//         for (var i = 0; i < value.length; i++) {
//             //
//             let row = lista.insertRow(-1)
//             row.id = value[i].item;
//             row.insertCell(0).innerHTML = LItems['' + value[i].item].name;
//             row.onclick = function () {
//                 //console.log(row.id);
//                 const row_old = document.getElementsByClassName('rowSelected')[0];
//                 if (row_old) {
//                     row_old.style.backgroundColor = 'rgba(65, 65, 65, 0)';
//                     row_old.classList.remove('rowSelected');
//                 }

//                 row.style.backgroundColor = 'rgba(65, 65, 65, 0.7)';
//                 row.classList.add('rowSelected');

//                 document.getElementById('preview').innerHTML = LItems['' + row.id].name;
//                 // const img = document.getElementById('img');
//                 // console.log(img)
//                 // img.src = 'http://mta/gm_files/images/items/' + value[i].item + '.png';
//             };
//         }
//     }
// }



// function changeLogin(str) {
//     if (str == 'sign'){
//         document.getElementById('titl').innerHTML = 'Registro';
//         document.getElementsByClassName('login-box')[0].style.display = 'none';
//         document.getElementsByClassName('sign-box')[0].style.display = 'initial';
//     }else{
//         document.getElementById('titl').innerHTML = 'Login Panel'
//         document.getElementsByClassName('login-box')[0].style.display = 'initial';
//         document.getElementsByClassName('sign-box')[0].style.display = 'none';
//     }
// }

// function onLogSig(value) {
//     if (value == 1){
//         const k =  document.getElementsByClassName('login-box')[0];
//         const v = k.getElementsByTagName("input");

//         mta.triggerEvent('onLogin', v[0].value, v[1].value);
//     }else{
//         const k =  document.getElementsByClassName('sign-box')[0];
//         const v = k.getElementsByTagName("input");

//         mta.triggerEvent('onSign', v[0].value, v[1].value, v[2].value);
//         //console.log(v.length);
//     }
// }

// function saveDatos(){
//     var box = document.getElementById('check');
//     if (box.checked == true){
//         const k =  document.getElementsByClassName('login-box')[0];
//         const v = k.getElementsByTagName("input");

//         mta.triggerEvent('onSaveDatos', 0, v[0].value, v[1].value);
//     } else {
//         mta.triggerEvent('onSaveDatos', 1);
//     }
// }
