select {
    width: 100% !important;
    margin-bottom: 5px !important;
}

.hidden {
    display: none;
}

.valign-top {
    vertical-align: top !important;
}

.halign-right {
    text-align: right !important;
}

.width-25 {
    width: 25% !important;
}

.p-around--x-small {
    padding: 0.5rem;
}

.p-right--x-small {
    padding-right: 0.5rem !important;
}

.progress {
    border: 1px solid #b8c3ca;
    border-radius: 3px;
    margin-bottom: 5px;
}

.progress-msg {
    position: relative;
    top: 1px;
    left: 3px;
}

.text-danger {
    color: #f44336;
}

.label {
    font-size: 0.75rem;
    color: #54698d;
}

.selectize-control {
    margin-bottom: 5px !important;
}

.selectize-control::before {
    -moz-transition: opacity 0.2s;
    -webkit-transition: opacity 0.2s;
    transition: opacity 0.2s;
    content: ' ';
    z-index: 2;
    position: absolute;
    display: block;
    top: 50%;
    right: 34px;
    width: 16px;
    height: 16px;
    margin: -10px 0 0 0;
    background: url( /img/loading.gif );
    background-size: 16px 16px;
    opacity: 0;
}

.selectize-control.loading::before {
    opacity: 1;
}