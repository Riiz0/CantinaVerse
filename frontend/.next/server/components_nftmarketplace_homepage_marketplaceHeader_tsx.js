"use strict";
/*
 * ATTENTION: An "eval-source-map" devtool has been used.
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file with attached SourceMaps in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
exports.id = "components_nftmarketplace_homepage_marketplaceHeader_tsx";
exports.ids = ["components_nftmarketplace_homepage_marketplaceHeader_tsx"];
exports.modules = {

/***/ "./components/UseNavbarToggle.ts":
/*!***************************************!*\
  !*** ./components/UseNavbarToggle.ts ***!
  \***************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export */ __webpack_require__.d(__webpack_exports__, {\n/* harmony export */   useNavbarToggle: () => (/* binding */ useNavbarToggle)\n/* harmony export */ });\n/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react */ \"react\");\n/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_0__);\n/* __next_internal_client_entry_do_not_use__ useNavbarToggle auto */ \nconst useNavbarToggle = ()=>{\n    (0,react__WEBPACK_IMPORTED_MODULE_0__.useEffect)(()=>{\n        const overlay = document.querySelector(\"[data-overlay]\");\n        const navbar = document.querySelector(\"[data-navbar]\");\n        const menuCloseBtn = document.querySelector(\"[data-nav-close-btn]\");\n        const menuOpenBtn = document.querySelector(\"[data-nav-open-btn]\");\n        const header = document.querySelector(\"[data-header]\");\n        const backTopBtn = document.querySelector(\"[data-back-top-btn]\");\n        const toggleActive = ()=>{\n            navbar?.classList.toggle(\"active\");\n            overlay?.classList.toggle(\"active\");\n        };\n        const elemArr = [\n            overlay,\n            menuCloseBtn,\n            menuOpenBtn\n        ];\n        elemArr.forEach((elem)=>{\n            elem?.addEventListener(\"click\", toggleActive);\n        });\n        const handleScroll = ()=>{\n            if (window.scrollY >= 100) {\n                header?.classList.add(\"active\");\n                backTopBtn?.classList.add(\"active\");\n            } else {\n                header?.classList.remove(\"active\");\n                backTopBtn?.classList.remove(\"active\");\n            }\n        };\n        window.addEventListener(\"scroll\", handleScroll);\n        // Cleanup event listeners on unmount\n        return ()=>{\n            elemArr.forEach((elem)=>{\n                elem?.removeEventListener(\"click\", toggleActive);\n            });\n            window.removeEventListener(\"scroll\", handleScroll);\n        };\n    }, []);\n};\n//# sourceURL=[module]\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiLi9jb21wb25lbnRzL1VzZU5hdmJhclRvZ2dsZS50cyIsIm1hcHBpbmdzIjoiOzs7Ozs7cUVBQ2tDO0FBSTNCLE1BQU1DLGtCQUFrQjtJQUM3QkQsZ0RBQVNBLENBQUM7UUFDUixNQUFNRSxVQUFVQyxTQUFTQyxhQUFhLENBQUM7UUFDdkMsTUFBTUMsU0FBU0YsU0FBU0MsYUFBYSxDQUFDO1FBQ3RDLE1BQU1FLGVBQWVILFNBQVNDLGFBQWEsQ0FBQztRQUM1QyxNQUFNRyxjQUFjSixTQUFTQyxhQUFhLENBQUM7UUFDM0MsTUFBTUksU0FBU0wsU0FBU0MsYUFBYSxDQUFDO1FBQ3RDLE1BQU1LLGFBQWFOLFNBQVNDLGFBQWEsQ0FBQztRQUUxQyxNQUFNTSxlQUFlO1lBQ25CTCxRQUFRTSxVQUFVQyxPQUFPO1lBQ3pCVixTQUFTUyxVQUFVQyxPQUFPO1FBQzVCO1FBRUEsTUFBTUMsVUFBb0M7WUFBQ1g7WUFBU0k7WUFBY0M7U0FBWTtRQUU5RU0sUUFBUUMsT0FBTyxDQUFDQyxDQUFBQTtZQUNkQSxNQUFNQyxpQkFBaUIsU0FBU047UUFDbEM7UUFFQSxNQUFNTyxlQUFlO1lBQ25CLElBQUlDLE9BQU9DLE9BQU8sSUFBSSxLQUFLO2dCQUN6QlgsUUFBUUcsVUFBVVMsSUFBSTtnQkFDdEJYLFlBQVlFLFVBQVVTLElBQUk7WUFDNUIsT0FBTztnQkFDTFosUUFBUUcsVUFBVVUsT0FBTztnQkFDekJaLFlBQVlFLFVBQVVVLE9BQU87WUFDL0I7UUFDRjtRQUVBSCxPQUFPRixnQkFBZ0IsQ0FBQyxVQUFVQztRQUVsQyxxQ0FBcUM7UUFDckMsT0FBTztZQUNMSixRQUFRQyxPQUFPLENBQUNDLENBQUFBO2dCQUNkQSxNQUFNTyxvQkFBb0IsU0FBU1o7WUFDckM7WUFDQVEsT0FBT0ksbUJBQW1CLENBQUMsVUFBVUw7UUFDdkM7SUFDRixHQUFHLEVBQUU7QUFDUCxFQUFFIiwic291cmNlcyI6WyJ3ZWJwYWNrOi8vZnJvbnRlbmQvLi9jb21wb25lbnRzL1VzZU5hdmJhclRvZ2dsZS50cz8yMjkyIl0sInNvdXJjZXNDb250ZW50IjpbIid1c2UgY2xpZW50JztcbmltcG9ydCB7IHVzZUVmZmVjdCB9IGZyb20gJ3JlYWN0JztcblxuaW50ZXJmYWNlIE5hdmJhckVsZW1lbnQgZXh0ZW5kcyBIVE1MRWxlbWVudCB7fVxuXG5leHBvcnQgY29uc3QgdXNlTmF2YmFyVG9nZ2xlID0gKCkgPT4ge1xuICB1c2VFZmZlY3QoKCkgPT4ge1xuICAgIGNvbnN0IG92ZXJsYXkgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCdbZGF0YS1vdmVybGF5XScpIGFzIE5hdmJhckVsZW1lbnQgfCBudWxsO1xuICAgIGNvbnN0IG5hdmJhciA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJ1tkYXRhLW5hdmJhcl0nKSBhcyBOYXZiYXJFbGVtZW50IHwgbnVsbDtcbiAgICBjb25zdCBtZW51Q2xvc2VCdG4gPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCdbZGF0YS1uYXYtY2xvc2UtYnRuXScpIGFzIE5hdmJhckVsZW1lbnQgfCBudWxsO1xuICAgIGNvbnN0IG1lbnVPcGVuQnRuID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcignW2RhdGEtbmF2LW9wZW4tYnRuXScpIGFzIE5hdmJhckVsZW1lbnQgfCBudWxsO1xuICAgIGNvbnN0IGhlYWRlciA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJ1tkYXRhLWhlYWRlcl0nKSBhcyBOYXZiYXJFbGVtZW50IHwgbnVsbDtcbiAgICBjb25zdCBiYWNrVG9wQnRuID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcignW2RhdGEtYmFjay10b3AtYnRuXScpIGFzIE5hdmJhckVsZW1lbnQgfCBudWxsO1xuXG4gICAgY29uc3QgdG9nZ2xlQWN0aXZlID0gKCkgPT4ge1xuICAgICAgbmF2YmFyPy5jbGFzc0xpc3QudG9nZ2xlKCdhY3RpdmUnKTtcbiAgICAgIG92ZXJsYXk/LmNsYXNzTGlzdC50b2dnbGUoJ2FjdGl2ZScpO1xuICAgIH07XG5cbiAgICBjb25zdCBlbGVtQXJyOiAoTmF2YmFyRWxlbWVudCB8IG51bGwpW10gPSBbb3ZlcmxheSwgbWVudUNsb3NlQnRuLCBtZW51T3BlbkJ0bl07XG5cbiAgICBlbGVtQXJyLmZvckVhY2goZWxlbSA9PiB7XG4gICAgICBlbGVtPy5hZGRFdmVudExpc3RlbmVyKCdjbGljaycsIHRvZ2dsZUFjdGl2ZSk7XG4gICAgfSk7XG5cbiAgICBjb25zdCBoYW5kbGVTY3JvbGwgPSAoKSA9PiB7XG4gICAgICBpZiAod2luZG93LnNjcm9sbFkgPj0gMTAwKSB7XG4gICAgICAgIGhlYWRlcj8uY2xhc3NMaXN0LmFkZCgnYWN0aXZlJyk7XG4gICAgICAgIGJhY2tUb3BCdG4/LmNsYXNzTGlzdC5hZGQoJ2FjdGl2ZScpO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgaGVhZGVyPy5jbGFzc0xpc3QucmVtb3ZlKCdhY3RpdmUnKTtcbiAgICAgICAgYmFja1RvcEJ0bj8uY2xhc3NMaXN0LnJlbW92ZSgnYWN0aXZlJyk7XG4gICAgICB9XG4gICAgfTtcblxuICAgIHdpbmRvdy5hZGRFdmVudExpc3RlbmVyKCdzY3JvbGwnLCBoYW5kbGVTY3JvbGwpO1xuXG4gICAgLy8gQ2xlYW51cCBldmVudCBsaXN0ZW5lcnMgb24gdW5tb3VudFxuICAgIHJldHVybiAoKSA9PiB7XG4gICAgICBlbGVtQXJyLmZvckVhY2goZWxlbSA9PiB7XG4gICAgICAgIGVsZW0/LnJlbW92ZUV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgdG9nZ2xlQWN0aXZlKTtcbiAgICAgIH0pO1xuICAgICAgd2luZG93LnJlbW92ZUV2ZW50TGlzdGVuZXIoJ3Njcm9sbCcsIGhhbmRsZVNjcm9sbCk7XG4gICAgfTtcbiAgfSwgW10pO1xufTsiXSwibmFtZXMiOlsidXNlRWZmZWN0IiwidXNlTmF2YmFyVG9nZ2xlIiwib3ZlcmxheSIsImRvY3VtZW50IiwicXVlcnlTZWxlY3RvciIsIm5hdmJhciIsIm1lbnVDbG9zZUJ0biIsIm1lbnVPcGVuQnRuIiwiaGVhZGVyIiwiYmFja1RvcEJ0biIsInRvZ2dsZUFjdGl2ZSIsImNsYXNzTGlzdCIsInRvZ2dsZSIsImVsZW1BcnIiLCJmb3JFYWNoIiwiZWxlbSIsImFkZEV2ZW50TGlzdGVuZXIiLCJoYW5kbGVTY3JvbGwiLCJ3aW5kb3ciLCJzY3JvbGxZIiwiYWRkIiwicmVtb3ZlIiwicmVtb3ZlRXZlbnRMaXN0ZW5lciJdLCJzb3VyY2VSb290IjoiIn0=\n//# sourceURL=webpack-internal:///./components/UseNavbarToggle.ts\n");

/***/ }),

/***/ "./components/nftmarketplace/homepage/marketplaceHeader.tsx":
/*!******************************************************************!*\
  !*** ./components/nftmarketplace/homepage/marketplaceHeader.tsx ***!
  \******************************************************************/
/***/ ((module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.a(module, async (__webpack_handle_async_dependencies__, __webpack_async_result__) => { try {\n__webpack_require__.r(__webpack_exports__);\n/* harmony export */ __webpack_require__.d(__webpack_exports__, {\n/* harmony export */   \"default\": () => (/* binding */ Header)\n/* harmony export */ });\n/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ \"react/jsx-dev-runtime\");\n/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);\n/* harmony import */ var _barrel_optimize_names_IoIosCloseCircleOutline_react_icons_io__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! __barrel_optimize__?names=IoIosCloseCircleOutline!=!react-icons/io */ \"./node_modules/react-icons/io/index.mjs\");\n/* harmony import */ var _barrel_optimize_names_TiThMenuOutline_react_icons_ti__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! __barrel_optimize__?names=TiThMenuOutline!=!react-icons/ti */ \"./node_modules/react-icons/ti/index.mjs\");\n/* harmony import */ var next_image__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! next/image */ \"./node_modules/next/image.js\");\n/* harmony import */ var next_image__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(next_image__WEBPACK_IMPORTED_MODULE_1__);\n/* harmony import */ var _UseNavbarToggle__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../UseNavbarToggle */ \"./components/UseNavbarToggle.ts\");\n/* harmony import */ var _rainbow_me_rainbowkit__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @rainbow-me/rainbowkit */ \"@rainbow-me/rainbowkit\");\n/* harmony import */ var next_link__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! next/link */ \"./node_modules/next/link.js\");\n/* harmony import */ var next_link__WEBPACK_IMPORTED_MODULE_4___default = /*#__PURE__*/__webpack_require__.n(next_link__WEBPACK_IMPORTED_MODULE_4__);\nvar __webpack_async_dependencies__ = __webpack_handle_async_dependencies__([_rainbow_me_rainbowkit__WEBPACK_IMPORTED_MODULE_3__]);\n_rainbow_me_rainbowkit__WEBPACK_IMPORTED_MODULE_3__ = (__webpack_async_dependencies__.then ? (await __webpack_async_dependencies__)() : __webpack_async_dependencies__)[0];\n/* __next_internal_client_entry_do_not_use__ default auto */ \n\n\n\n\n\n\nfunction Header() {\n    (0,_UseNavbarToggle__WEBPACK_IMPORTED_MODULE_2__.useNavbarToggle)();\n    return /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"header\", {\n        className: \"header\",\n        \"data-header\": true,\n        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n            className: \"container\",\n            children: [\n                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                    className: \"overlay\",\n                    \"data-overlay\": true\n                }, void 0, false, {\n                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                    lineNumber: 17,\n                    columnNumber: 9\n                }, this),\n                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                    href: \"/\",\n                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                        className: \"logo-wrapper\",\n                        children: [\n                            /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                className: \"logo\",\n                                children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_image__WEBPACK_IMPORTED_MODULE_1___default()), {\n                                    src: \"/assets/CantinaVerse_Transparent.svg\",\n                                    width: 68,\n                                    height: 48,\n                                    alt: \"NFTC Logo\"\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 23,\n                                    columnNumber: 15\n                                }, this)\n                            }, void 0, false, {\n                                fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                lineNumber: 22,\n                                columnNumber: 13\n                            }, this),\n                            /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"span\", {\n                                className: \"logo-text\",\n                                children: \"CantinaVerse\"\n                            }, void 0, false, {\n                                fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                lineNumber: 25,\n                                columnNumber: 13\n                            }, this),\n                            \" \"\n                        ]\n                    }, void 0, true, {\n                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                        lineNumber: 21,\n                        columnNumber: 11\n                    }, this)\n                }, void 0, false, {\n                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                    lineNumber: 20,\n                    columnNumber: 9\n                }, this),\n                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"nav\", {\n                    className: \"navbar\",\n                    \"data-navbar\": true,\n                    children: [\n                        /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                            className: \"navbar-top\",\n                            children: [\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"p\", {\n                                    className: \"navbar-title\",\n                                    children: \"Menu\"\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 32,\n                                    columnNumber: 13\n                                }, this),\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"button\", {\n                                    className: \"nav-close-btn\",\n                                    \"aria-label\": \"Close Menu\",\n                                    \"data-nav-close-btn\": true,\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(_barrel_optimize_names_IoIosCloseCircleOutline_react_icons_io__WEBPACK_IMPORTED_MODULE_5__.IoIosCloseCircleOutline, {}, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 35,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 34,\n                                    columnNumber: 13\n                                }, this)\n                            ]\n                        }, void 0, true, {\n                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                            lineNumber: 31,\n                            columnNumber: 11\n                        }, this),\n                        /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"ul\", {\n                            className: \"navbar-list\",\n                            children: [\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"li\", {\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                                        href: \"/marketplace\",\n                                        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                            className: \"navbar-link\",\n                                            \"data-navlink\": true,\n                                            children: \"Home\"\n                                        }, void 0, false, {\n                                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                            lineNumber: 41,\n                                            columnNumber: 41\n                                        }, this)\n                                    }, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 41,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 40,\n                                    columnNumber: 13\n                                }, this),\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"li\", {\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                                        href: \"/marketplace/explore\",\n                                        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                            className: \"navbar-link\",\n                                            \"data-navlink\": true,\n                                            children: \"Explore\"\n                                        }, void 0, false, {\n                                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                            lineNumber: 44,\n                                            columnNumber: 49\n                                        }, this)\n                                    }, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 44,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 43,\n                                    columnNumber: 13\n                                }, this),\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"li\", {\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                                        href: \"/marketplace/create\",\n                                        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                            className: \"navbar-link\",\n                                            \"data-navlink\": true,\n                                            children: \"Create\"\n                                        }, void 0, false, {\n                                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                            lineNumber: 47,\n                                            columnNumber: 48\n                                        }, this)\n                                    }, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 47,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 46,\n                                    columnNumber: 13\n                                }, this),\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"li\", {\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                                        href: \"/marketplace/mint\",\n                                        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                            className: \"navbar-link\",\n                                            \"data-navlink\": true,\n                                            children: \"Mint\"\n                                        }, void 0, false, {\n                                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                            lineNumber: 51,\n                                            columnNumber: 46\n                                        }, this)\n                                    }, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 51,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 50,\n                                    columnNumber: 13\n                                }, this),\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"li\", {\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                                        href: \"/marketplace/trade\",\n                                        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                            className: \"navbar-link\",\n                                            \"data-navlink\": true,\n                                            children: \"Trade\"\n                                        }, void 0, false, {\n                                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                            lineNumber: 54,\n                                            columnNumber: 47\n                                        }, this)\n                                    }, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 54,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 53,\n                                    columnNumber: 13\n                                }, this),\n                                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"li\", {\n                                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)((next_link__WEBPACK_IMPORTED_MODULE_4___default()), {\n                                        href: \"/marketplace/auction\",\n                                        children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"div\", {\n                                            className: \"navbar-link\",\n                                            \"data-navlink\": true,\n                                            children: \"Auction\"\n                                        }, void 0, false, {\n                                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                            lineNumber: 58,\n                                            columnNumber: 49\n                                        }, this)\n                                    }, void 0, false, {\n                                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                        lineNumber: 58,\n                                        columnNumber: 15\n                                    }, this)\n                                }, void 0, false, {\n                                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                                    lineNumber: 57,\n                                    columnNumber: 13\n                                }, this)\n                            ]\n                        }, void 0, true, {\n                            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                            lineNumber: 39,\n                            columnNumber: 11\n                        }, this)\n                    ]\n                }, void 0, true, {\n                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                    lineNumber: 29,\n                    columnNumber: 9\n                }, this),\n                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(\"button\", {\n                    className: \"menu-open-btn\",\n                    \"aria-label\": \"Open Menu\",\n                    \"data-nav-open-btn\": true,\n                    children: /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(_barrel_optimize_names_TiThMenuOutline_react_icons_ti__WEBPACK_IMPORTED_MODULE_6__.TiThMenuOutline, {}, void 0, false, {\n                        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                        lineNumber: 64,\n                        columnNumber: 11\n                    }, this)\n                }, void 0, false, {\n                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                    lineNumber: 63,\n                    columnNumber: 9\n                }, this),\n                /*#__PURE__*/ (0,react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__.jsxDEV)(_rainbow_me_rainbowkit__WEBPACK_IMPORTED_MODULE_3__.ConnectButton, {}, void 0, false, {\n                    fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n                    lineNumber: 67,\n                    columnNumber: 9\n                }, this)\n            ]\n        }, void 0, true, {\n            fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n            lineNumber: 15,\n            columnNumber: 7\n        }, this)\n    }, void 0, false, {\n        fileName: \"/home/srizo/code/personal-projects/sc-nft-marketplace/frontend/components/nftmarketplace/homepage/marketplaceHeader.tsx\",\n        lineNumber: 14,\n        columnNumber: 5\n    }, this);\n}\n\n__webpack_async_result__();\n} catch(e) { __webpack_async_result__(e); } });//# sourceURL=[module]\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiLi9jb21wb25lbnRzL25mdG1hcmtldHBsYWNlL2hvbWVwYWdlL21hcmtldHBsYWNlSGVhZGVyLnRzeCIsIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFFeUQ7QUFDUjtBQUNsQjtBQUN5QjtBQUNEO0FBQzFCO0FBRWQsU0FBU007SUFDdEJILGlFQUFlQTtJQUVmLHFCQUNFLDhEQUFDSTtRQUFPQyxXQUFVO1FBQVNDLGFBQVc7a0JBQ3BDLDRFQUFDQztZQUFJRixXQUFVOzs4QkFFYiw4REFBQ0U7b0JBQUlGLFdBQVU7b0JBQVVHLGNBQVk7Ozs7Ozs4QkFHckMsOERBQUNOLGtEQUFJQTtvQkFBQ08sTUFBSzs4QkFDVCw0RUFBQ0Y7d0JBQUlGLFdBQVU7OzBDQUNiLDhEQUFDRTtnQ0FBSUYsV0FBVTswQ0FDYiw0RUFBQ04sbURBQUtBO29DQUFDVyxLQUFJO29DQUF1Q0MsT0FBTztvQ0FBSUMsUUFBUTtvQ0FBSUMsS0FBSTs7Ozs7Ozs7Ozs7MENBRS9FLDhEQUFDQztnQ0FBS1QsV0FBVTswQ0FBWTs7Ozs7OzRCQUFtQjs7Ozs7Ozs7Ozs7OzhCQUluRCw4REFBQ1U7b0JBQUlWLFdBQVU7b0JBQVNXLGFBQVc7O3NDQUVqQyw4REFBQ1Q7NEJBQUlGLFdBQVU7OzhDQUNiLDhEQUFDWTtvQ0FBRVosV0FBVTs4Q0FBZTs7Ozs7OzhDQUU1Qiw4REFBQ2E7b0NBQU9iLFdBQVU7b0NBQWdCYyxjQUFXO29DQUFhQyxvQkFBa0I7OENBQzFFLDRFQUFDdkIsa0hBQXVCQTs7Ozs7Ozs7Ozs7Ozs7OztzQ0FJNUIsOERBQUN3Qjs0QkFBR2hCLFdBQVU7OzhDQUNaLDhEQUFDaUI7OENBQ0MsNEVBQUNwQixrREFBSUE7d0NBQUNPLE1BQUs7a0RBQWUsNEVBQUNGOzRDQUFJRixXQUFVOzRDQUFja0IsY0FBWTtzREFBQzs7Ozs7Ozs7Ozs7Ozs7Ozs4Q0FFdEUsOERBQUNEOzhDQUNDLDRFQUFDcEIsa0RBQUlBO3dDQUFDTyxNQUFLO2tEQUF1Qiw0RUFBQ0Y7NENBQUlGLFdBQVU7NENBQWNrQixjQUFZO3NEQUFDOzs7Ozs7Ozs7Ozs7Ozs7OzhDQUU5RSw4REFBQ0Q7OENBQ0MsNEVBQUNwQixrREFBSUE7d0NBQUNPLE1BQUs7a0RBQXNCLDRFQUFDRjs0Q0FBSUYsV0FBVTs0Q0FBY2tCLGNBQVk7c0RBQUM7Ozs7Ozs7Ozs7Ozs7Ozs7OENBRzdFLDhEQUFDRDs4Q0FDQyw0RUFBQ3BCLGtEQUFJQTt3Q0FBQ08sTUFBSztrREFBb0IsNEVBQUNGOzRDQUFJRixXQUFVOzRDQUFja0IsY0FBWTtzREFBQzs7Ozs7Ozs7Ozs7Ozs7Ozs4Q0FFM0UsOERBQUNEOzhDQUNDLDRFQUFDcEIsa0RBQUlBO3dDQUFDTyxNQUFLO2tEQUFxQiw0RUFBQ0Y7NENBQUlGLFdBQVU7NENBQWNrQixjQUFZO3NEQUFDOzs7Ozs7Ozs7Ozs7Ozs7OzhDQUc1RSw4REFBQ0Q7OENBQ0MsNEVBQUNwQixrREFBSUE7d0NBQUNPLE1BQUs7a0RBQXVCLDRFQUFDRjs0Q0FBSUYsV0FBVTs0Q0FBY2tCLGNBQVk7c0RBQUM7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OEJBS2xGLDhEQUFDTDtvQkFBT2IsV0FBVTtvQkFBZ0JjLGNBQVc7b0JBQVlLLG1CQUFpQjs4QkFDeEUsNEVBQUMxQixrR0FBZUE7Ozs7Ozs7Ozs7OEJBR2xCLDhEQUFDRyxpRUFBYUE7Ozs7Ozs7Ozs7Ozs7Ozs7QUFLdEIiLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly9mcm9udGVuZC8uL2NvbXBvbmVudHMvbmZ0bWFya2V0cGxhY2UvaG9tZXBhZ2UvbWFya2V0cGxhY2VIZWFkZXIudHN4P2JiYzAiXSwic291cmNlc0NvbnRlbnQiOlsiJ3VzZSBjbGllbnQnO1xuXG5pbXBvcnQgeyBJb0lvc0Nsb3NlQ2lyY2xlT3V0bGluZSB9IGZyb20gXCJyZWFjdC1pY29ucy9pb1wiO1xuaW1wb3J0IHsgVGlUaE1lbnVPdXRsaW5lIH0gZnJvbSBcInJlYWN0LWljb25zL3RpXCI7XG5pbXBvcnQgSW1hZ2UgZnJvbSAnbmV4dC9pbWFnZSc7XG5pbXBvcnQgeyB1c2VOYXZiYXJUb2dnbGUgfSBmcm9tICcuLi8uLi9Vc2VOYXZiYXJUb2dnbGUnO1xuaW1wb3J0IHsgQ29ubmVjdEJ1dHRvbiB9IGZyb20gJ0ByYWluYm93LW1lL3JhaW5ib3draXQnO1xuaW1wb3J0IExpbmsgZnJvbSAnbmV4dC9saW5rJztcblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gSGVhZGVyKCkge1xuICB1c2VOYXZiYXJUb2dnbGUoKTtcblxuICByZXR1cm4gKFxuICAgIDxoZWFkZXIgY2xhc3NOYW1lPVwiaGVhZGVyXCIgZGF0YS1oZWFkZXI+XG4gICAgICA8ZGl2IGNsYXNzTmFtZT1cImNvbnRhaW5lclwiPlxuXG4gICAgICAgIDxkaXYgY2xhc3NOYW1lPVwib3ZlcmxheVwiIGRhdGEtb3ZlcmxheT48L2Rpdj5cblxuICAgICAgICB7LyogV3JhcCBib3RoIHRoZSBsb2dvIGFuZCB0aGUgdGV4dCBpbiBhIHNpbmdsZSBMaW5rICovfVxuICAgICAgICA8TGluayBocmVmPVwiL1wiPlxuICAgICAgICAgIDxkaXYgY2xhc3NOYW1lPVwibG9nby13cmFwcGVyXCI+XG4gICAgICAgICAgICA8ZGl2IGNsYXNzTmFtZT1cImxvZ29cIj5cbiAgICAgICAgICAgICAgPEltYWdlIHNyYz1cIi9hc3NldHMvQ2FudGluYVZlcnNlX1RyYW5zcGFyZW50LnN2Z1wiIHdpZHRoPXs2OH0gaGVpZ2h0PXs0OH0gYWx0PVwiTkZUQyBMb2dvXCIgLz5cbiAgICAgICAgICAgIDwvZGl2PlxuICAgICAgICAgICAgPHNwYW4gY2xhc3NOYW1lPVwibG9nby10ZXh0XCI+Q2FudGluYVZlcnNlPC9zcGFuPiB7LyogQWRkIHlvdXIgdGV4dCBoZXJlICovfVxuICAgICAgICAgIDwvZGl2PlxuICAgICAgICA8L0xpbms+XG5cbiAgICAgICAgPG5hdiBjbGFzc05hbWU9XCJuYXZiYXJcIiBkYXRhLW5hdmJhcj5cblxuICAgICAgICAgIDxkaXYgY2xhc3NOYW1lPVwibmF2YmFyLXRvcFwiPlxuICAgICAgICAgICAgPHAgY2xhc3NOYW1lPVwibmF2YmFyLXRpdGxlXCI+TWVudTwvcD5cblxuICAgICAgICAgICAgPGJ1dHRvbiBjbGFzc05hbWU9XCJuYXYtY2xvc2UtYnRuXCIgYXJpYS1sYWJlbD1cIkNsb3NlIE1lbnVcIiBkYXRhLW5hdi1jbG9zZS1idG4+XG4gICAgICAgICAgICAgIDxJb0lvc0Nsb3NlQ2lyY2xlT3V0bGluZSAvPlxuICAgICAgICAgICAgPC9idXR0b24+XG4gICAgICAgICAgPC9kaXY+XG5cbiAgICAgICAgICA8dWwgY2xhc3NOYW1lPVwibmF2YmFyLWxpc3RcIj5cbiAgICAgICAgICAgIDxsaT5cbiAgICAgICAgICAgICAgPExpbmsgaHJlZj1cIi9tYXJrZXRwbGFjZVwiPjxkaXYgY2xhc3NOYW1lPVwibmF2YmFyLWxpbmtcIiBkYXRhLW5hdmxpbms+SG9tZTwvZGl2PjwvTGluaz5cbiAgICAgICAgICAgIDwvbGk+XG4gICAgICAgICAgICA8bGk+XG4gICAgICAgICAgICAgIDxMaW5rIGhyZWY9XCIvbWFya2V0cGxhY2UvZXhwbG9yZVwiPjxkaXYgY2xhc3NOYW1lPVwibmF2YmFyLWxpbmtcIiBkYXRhLW5hdmxpbms+RXhwbG9yZTwvZGl2PjwvTGluaz5cbiAgICAgICAgICAgIDwvbGk+XG4gICAgICAgICAgICA8bGk+XG4gICAgICAgICAgICAgIDxMaW5rIGhyZWY9XCIvbWFya2V0cGxhY2UvY3JlYXRlXCI+PGRpdiBjbGFzc05hbWU9XCJuYXZiYXItbGlua1wiIGRhdGEtbmF2bGluaz5DcmVhdGU8L2Rpdj48L0xpbms+XG4gICAgICAgICAgICA8L2xpPlxuXG4gICAgICAgICAgICA8bGk+XG4gICAgICAgICAgICAgIDxMaW5rIGhyZWY9XCIvbWFya2V0cGxhY2UvbWludFwiPjxkaXYgY2xhc3NOYW1lPVwibmF2YmFyLWxpbmtcIiBkYXRhLW5hdmxpbms+TWludDwvZGl2PjwvTGluaz5cbiAgICAgICAgICAgIDwvbGk+XG4gICAgICAgICAgICA8bGk+XG4gICAgICAgICAgICAgIDxMaW5rIGhyZWY9XCIvbWFya2V0cGxhY2UvdHJhZGVcIj48ZGl2IGNsYXNzTmFtZT1cIm5hdmJhci1saW5rXCIgZGF0YS1uYXZsaW5rPlRyYWRlPC9kaXY+PC9MaW5rPlxuICAgICAgICAgICAgPC9saT5cblxuICAgICAgICAgICAgPGxpPlxuICAgICAgICAgICAgICA8TGluayBocmVmPVwiL21hcmtldHBsYWNlL2F1Y3Rpb25cIj48ZGl2IGNsYXNzTmFtZT1cIm5hdmJhci1saW5rXCIgZGF0YS1uYXZsaW5rPkF1Y3Rpb248L2Rpdj48L0xpbms+XG4gICAgICAgICAgICA8L2xpPlxuICAgICAgICAgIDwvdWw+XG4gICAgICAgIDwvbmF2PlxuXG4gICAgICAgIDxidXR0b24gY2xhc3NOYW1lPVwibWVudS1vcGVuLWJ0blwiIGFyaWEtbGFiZWw9XCJPcGVuIE1lbnVcIiBkYXRhLW5hdi1vcGVuLWJ0bj5cbiAgICAgICAgICA8VGlUaE1lbnVPdXRsaW5lIC8+XG4gICAgICAgIDwvYnV0dG9uPlxuXG4gICAgICAgIDxDb25uZWN0QnV0dG9uIC8+XG5cbiAgICAgIDwvZGl2PlxuICAgIDwvaGVhZGVyPlxuICApO1xufSJdLCJuYW1lcyI6WyJJb0lvc0Nsb3NlQ2lyY2xlT3V0bGluZSIsIlRpVGhNZW51T3V0bGluZSIsIkltYWdlIiwidXNlTmF2YmFyVG9nZ2xlIiwiQ29ubmVjdEJ1dHRvbiIsIkxpbmsiLCJIZWFkZXIiLCJoZWFkZXIiLCJjbGFzc05hbWUiLCJkYXRhLWhlYWRlciIsImRpdiIsImRhdGEtb3ZlcmxheSIsImhyZWYiLCJzcmMiLCJ3aWR0aCIsImhlaWdodCIsImFsdCIsInNwYW4iLCJuYXYiLCJkYXRhLW5hdmJhciIsInAiLCJidXR0b24iLCJhcmlhLWxhYmVsIiwiZGF0YS1uYXYtY2xvc2UtYnRuIiwidWwiLCJsaSIsImRhdGEtbmF2bGluayIsImRhdGEtbmF2LW9wZW4tYnRuIl0sInNvdXJjZVJvb3QiOiIifQ==\n//# sourceURL=webpack-internal:///./components/nftmarketplace/homepage/marketplaceHeader.tsx\n");

/***/ })

};
;