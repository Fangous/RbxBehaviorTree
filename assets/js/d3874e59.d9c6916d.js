"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{52897:(e,t,a)=>{a.r(t),a.d(t,{HomepageFeatures:()=>d,default:()=>E});var n=a(87462),r=a(39960),l=a(52263),s=a(34510),i=a(86010),c=a(67294);const o={heroBanner:"heroBanner_e1Bh",buttons:"buttons_VwD3",features:"features_WS6B",featureSvg:"featureSvg_tqLR",titleOnBannerImage:"titleOnBannerImage_r7kd",taglineOnBannerImage:"taglineOnBannerImage_dLPr"},m=[{title:"Visualizer Plugin",description:"Our plugin allows for quick and easy debugging of larger behavior trees."},{title:"Rojo Friendly",description:"All of your behavior trees are created declaratively using primitives."},{title:"Composable",description:"Nodes used by multiple behavior trees can be broken up into modules/factories for easy reuse."}];function u(e){let{image:t,title:a,description:n}=e;return c.createElement("div",{className:(0,i.Z)("col col--4")},t&&c.createElement("div",{className:"text--center"},c.createElement("img",{className:o.featureSvg,alt:a,src:t})),c.createElement("div",{className:"text--center padding-horiz--md"},c.createElement("h3",null,a),c.createElement("p",null,n)))}function d(){return m?c.createElement("section",{className:o.features},c.createElement("div",{className:"container"},c.createElement("div",{className:"row"},m.map(((e,t)=>c.createElement(u,(0,n.Z)({key:t},e))))))):null}function g(){const{siteConfig:e}=(0,l.Z)(),t=e.customFields.bannerImage,a=!!t,n=a?{backgroundImage:`url("${t}")`}:null,s=(0,i.Z)("hero__title",{[o.titleOnBannerImage]:a}),m=(0,i.Z)("hero__subtitle",{[o.taglineOnBannerImage]:a});return c.createElement("header",{className:(0,i.Z)("hero",o.heroBanner),style:n},c.createElement("div",{className:"container"},c.createElement("h1",{className:s},e.title),c.createElement("p",{className:m},e.tagline),c.createElement("div",{className:o.buttons},c.createElement(r.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function E(){const{siteConfig:e,tagline:t}=(0,l.Z)();return c.createElement(s.Z,{title:e.title,description:t},c.createElement(g,null),c.createElement("main",null,c.createElement(d,null),c.createElement("div",{className:"container"})))}}}]);