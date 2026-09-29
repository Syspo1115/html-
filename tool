<!doctype html>
<html lang="zh-Hant">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#ffffff">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">

<title>咪咪大神的柴薪銀</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: #f7f7f7;
    color: #222;
    font-family:
        -apple-system,
        BlinkMacSystemFont,
        "PingFang TC",
        "Noto Sans TC",
        sans-serif;
}

main {
    max-width: 520px;
    margin: auto;
    padding: 16px 15px 38px;
    position: relative;
    min-height: 100vh;
}

h1 {
    font-size: 25px;
    margin: 5px 0 14px;
}

nav {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 7px;
}

button {
    border: 0;
    border-radius: 12px;
    padding: 12px;
    font-size: 16px;
    font-weight: 600;
    background: #222;
    color: #fff;
}

nav button {
    font-size: 14px;
    padding: 10px;
}

nav button.on {
    background: #555;
}

.card {
    background: #fff;
    border-radius: 17px;
    padding: 17px;
    margin-top: 12px;
    box-shadow: 0 2px 10px #0000000b;
}

label {
    display: block;
    font-size: 14px;
    color: #666;
    margin: 9px 0 5px;
}

input {
    width: 100%;
    padding: 12px;
    border: 1px solid #ddd;
    border-radius: 11px;
    font: inherit;
    background: #fff;
}

.row {
    display: flex;
    gap: 10px;
}

.row > div {
    flex: 1;
}

.big {
    font-size: 24px;
    font-weight: 700;
    margin-top: 3px;
}

.muted {
    font-size: 13px;
    color: #777;
}

.item {
    padding: 10px 0;
    border-bottom: 1px solid #eee;
}

.total {
    display: flex;
    justify-content: space-between;
    font-weight: 700;
    margin-top: 12px;
}

.hidden {
    display: none;
}

.art {
    position: fixed;
    right: -18px;
    bottom: -8px;
    width: 105px;
    opacity: .95;
    pointer-events: none;
    z-index: 0;
}

.content {
    position: relative;
    z-index: 1;
    padding-bottom: 95px;
}
</style>
</head>

<body>

<main>

<div class="content">

<h1>咪咪大神的柴薪銀</h1>

<nav>
    <button id="bn1" onclick="page('input')">
        輸入資料
    </button>

    <button id="bn2" onclick="page('settle')">
        本月結算
    </button>

    <button id="bn3" onclick="page('history')">
        每月紀錄
    </button>
</nav>


<!-- =========================
     輸入資料
========================= -->

<section id="input" class="card">

<h2>輸入資料</h2>

<label>時薪</label>

<input
    id="rate"
    type="number"
    min="0"
    step="1"
    placeholder="例如 200"
>


<label>日期</label>

<input
    id="date"
    type="date"
>


<div class="row">

<div>

<label>上班時間</label>

<input
    id="start"
    type="time"
>

</div>


<div>

<label>下班時間</label>

<input
    id="end"
    type="time"
>

</div>

</div>


<div
    class="card"
    style="background:#f7f7f7;margin-top:14px"
>

<div class="muted">
    本次工時
</div>

<div
    class="big"
    id="duration"
>
    0 小時 0 分
</div>

<div
    class="muted"
    id="decimal"
>
    0 小時
</div>

</div>


<button onclick="addWork()">
    加入本月工時
</button>


<div id="list"></div>


<div class="total">

<span>
    本月總工時
</span>

<span id="hours">
    0 小時
</span>

</div>


<div class="total">

<span>
    目前應得薪資
</span>

<span id="pay">
    $0
</span>

</div>

</section>



<!-- =========================
     本月結算
========================= -->

<section
    id="settle"
    class="card hidden"
>

<h2>本月結算</h2>

<div
    class="muted"
    id="sm"
></div>


<div class="total">

<span>
    總工時
</span>

<span id="sh">
    0
</span>

</div>


<div class="total">

<span>
    計算薪資
</span>

<span id="sp">
    $0
</span>

</div>


<label>
    實收金額
</label>

<input
    id="received"
    type="number"
    min="0"
    step="1"
    placeholder="輸入實際收到的金額"
>


<button onclick="settle()">
    結算本月
</button>


<p class="muted">
    由你自己按「結算」，不會自動結算。
</p>

</section>



<!-- =========================
     每月紀錄
========================= -->

<section
    id="history"
    class="card hidden"
>

<h2>
    每月結算紀錄
</h2>

<div
    id="hist"
    class="muted"
>
    尚無紀錄
</div>

</section>

</div>


<!-- =========================
     右下角人物圖
========================= -->

<img
    class="art"
    src="data:image/jpeg;base64,請將你提供的圖片轉成Base64後放在這裡"
    alt=""
>


<script>

/* =====================================
   資料儲存
===================================== */

const KEY = 'mimi_salary_v2';

let db = JSON.parse(
    localStorage.getItem(KEY)
    ||
    '{"months":{}}'
);


/* =====================================
   今天日期
===================================== */

const today = () => {
    return new Date()
        .toISOString()
        .slice(0,10);
};


/* =====================================
   年月
===================================== */

const ym = d => {
    return d.slice(0,7);
};


/* =====================================
   取得目前月份
===================================== */

function current() {

    let m = ym(
        date.value || today()
    );

    if (!db.months[m]) {

        db.months[m] = {

            rate:
                +rate.value || 0,

            works: [],

            settled: false

        };

    }

    return db.months[m];
}


/* =====================================
   儲存資料
===================================== */

function save() {

    localStorage.setItem(
        KEY,
        JSON.stringify(db)
    );

}


/* =====================================
   計算工時
===================================== */

function durationMin() {

    if (
        !start.value ||
        !end.value
    ) {
        return 0;
    }


    let a =
        start.value
        .split(':')
        .map(Number);


    let b =
        end.value
        .split(':')
        .map(Number);


    let m =
        b[0] * 60 +
        b[1] -
        a[0] * 60 -
        a[1];


    /*
       如果跨午夜
       自動加一天
    */

    if (m < 0) {

        m += 1440;

    }


    return m;
}


/* =====================================
   顯示本次工時
===================================== */

function update() {

    let m =
        durationMin();


    duration.textContent =
        Math.floor(m / 60)
        +
        ' 小時 '
        +
        (m % 60)
        +
        ' 分';


    decimal.textContent =
        (m / 60).toFixed(2)
        +
        ' 小時';

}


/* =====================================
   更新畫面
===================================== */

function refresh() {

    let a =
        current();


    let m =
        ym(date.value);


    let mins =
        a.works.reduce(
            (s,x) =>
                s + x.minutes,
            0
        );


    let h =
        mins / 60;


    let p =
        Math.round(
            h * a.rate
        );


    /* 工作紀錄 */

    list.innerHTML =
        a.works
        .map(x => {

            return `
            <div class="item">

                ${x.date}
               　
                ${x.start}
                –
                ${x.end}

                <br>

                <span class="muted">

                    ${Math.floor(x.minutes / 60)}
                    小時

                    ${x.minutes % 60}
                    分

                    ＝

                    ${(x.minutes / 60).toFixed(2)}
                    小時

                </span>

            </div>
            `;

        })
        .join('')
        ||
        '<p class="muted">尚未加入工作資料</p>';


    /* 本月總工時 */

    hours.textContent =
        h.toFixed(2)
        +
        ' 小時';


    /* 目前薪資 */

    pay.textContent =
        '$'
        +
        p.toLocaleString();


    /* 結算頁 */

    sm.textContent =
        m;


    sh.textContent =
        h.toFixed(2)
        +
        ' 小時';


    sp.textContent =
        '$'
        +
        p.toLocaleString();


    /* 歷史紀錄 */

    hist.innerHTML =

        Object.keys(
            db.months
        )
        .sort()
        .reverse()
        .map(k => {

            let x =
                db.months[k];


            let q =
                x.works.reduce(
                    (s,z) =>
                        s + z.minutes,
                    0
                ) / 60;


            let pp =
                Math.round(
                    q * x.rate
                );


            return `
            <div class="item">

                <b>${k}</b>

                <br>

                時薪
                $${x.rate.toLocaleString()}

               　
                
                工時
                ${q.toFixed(2)}
                小時

                <br>

                應得
                $${pp.toLocaleString()}

               　
                
                實收
                ${
                    x.received == null
                    ? '—'
                    : '$'
                    +
                    Number(
                        x.received
                    ).toLocaleString()
                }

                <br>

                <span class="muted">

                    ${
                        x.settled
                        ? '已結算'
                        : '尚未結算'
                    }

                </span>

            </div>
            `;

        })
        .join('')
        ||
        '尚無紀錄';


    save();

}


/* =====================================
   加入工作
===================================== */

function addWork() {

    let m =
        durationMin();


    if (
        !date.value ||
        !start.value ||
        !end.value
    ) {

        alert(
            '請填寫日期、上班時間、下班時間'
        );

        return;

    }


    let a =
        current();


    a.rate =
        +rate.value ||
        a.rate;


    if (!a.rate) {

        alert(
            '請先輸入時薪'
        );

        return;

    }


    a.works.push({

        date:
            date.value,

        start:
            start.value,

        end:
            end.value,

        minutes:
            m

    });


    save();

    refresh();

}


/* =====================================
   本月結算
===================================== */

function settle() {

    let a =
        current();


    a.received =
        received.value === ''
        ? null
        : +received.value;


    a.settled =
        true;


    save();

    refresh();


    alert(
        '本月已結算並保存。'
    );

}


/* =====================================
   切換頁面
===================================== */

function page(id) {

    [
        'input',
        'settle',
        'history'
    ]
    .forEach(x => {

        document
            .getElementById(x)
            .classList
            .toggle(
                'hidden',
                x !== id
            );

    });


    [
        'bn1',
        'bn2',
        'bn3'
    ]
    .forEach(
        (x,i) => {

            document
                .getElementById(x)
                .classList
                .toggle(
                    'on',
                    [
                        'input',
                        'settle',
                        'history'
                    ][i]
                    === id
                );

        }
    );


    refresh();

}


/* =====================================
   即時更新工時
===================================== */

start.oninput =
end.oninput =
update;


/* =====================================
   日期改變
===================================== */

date.onchange =
refresh;


/* =====================================
   時薪改變
===================================== */

rate.oninput =
refresh;


/* =====================================
   預設今天
===================================== */

date.value =
today();


/* =====================================
   開啟程式
===================================== */

page('input');

</script>

</body>
</html>