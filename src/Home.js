import React, { Component } from "react";
import ReactGA from 'react-ga';
import { NavLink } from "react-router-dom";

import Image1 from "./Image1";
import iosShare from "./assets/iosShare.png";
import iosAdd from "./assets/iosAdd.png";
import iosConfirm from "./assets/iosConfirm.png";
import android1 from "./assets/android1.png";
import android2 from "./assets/android2.png";

// import Image from "./Image";
// import logo from "./assets/favicon-192.png";
class Home extends Component {
    render() {
        ReactGA.set({ "page": "Home"});
        ReactGA.pageview("/Home");
        
        return <div>
                <h2>Welcome to Belles Run Philadelphia 2019!</h2>
                <br/>
                <h3>Updates</h3><p>Open this app twice for the latest</p>
                <ul>
            <li>Text Dan Lyke, 415-342-5180, with updates</li>
                </ul>
                <h3>Fast facts</h3>
                <ul>
                    <li>
                        <b>Hotel</b>
                        <br />
                        <a target="_blank" rel="noopener noreferrer" href="https://www.marriott.com/hotels/travel/phlws-philadelphia-201-hotel/">Philadephia 201 Hotel</a>
                        <br />
                        <a target="_blank" rel="noopener noreferrer" href="https://www.google.com/maps/place/201+N+17th+St,+Philadelphia,+PA+19103/data=!4m2!3m1!1s0x89c6c632880cc80d:0x822a9fbfdcd7a946?sa=X&ved=2ahUKEwivkf2m3f3iAhUjgK0KHeoaC4wQ8gEwAHoECAoQAQ">
                             201 North 17th Street, Philadelphia, Pennsylvania 19103 USA
                        </a>
                        <br />
                        Phone: 215-448-2000
                    </li>
                    <li>
                        See <a target="_blank" rel="noopener noreferrer" href="https://www.philadelphia2019.com/">
            philadelphia2019.com
                        </a> for&nbsp;
                        <a target="_blank" rel="noopener noreferrer" href="https://www.philadelphia2019.com/index.php/transportation">transportation options</a> and more.
                    </li>
                    <li>
                        <b>Square Dancing</b>
                        <br />
                        <NavLink to="/schedule" key="/schedule">
                            Thurs July 5 - Sat July 7
                        </NavLink>
                    </li>
                </ul>
                <br />
                {this.installInstructions()}
                <br />
                <h2>Feedback?</h2>
            <p>If there's something you'd like different in this app, find Dan Lyke and tell him.</p>
                <br />
                <br />
                <br />
                <span className="finePrint">
                    <p>Updated: Sat Jun 22 11:58:46 PDT 2019</p>
                </span>
                <span className="finePrint">
                    <p>
                        Details: {navigator.platform} {window.navigator.userAgent}{" "}
                    </p>
                </span>
            </div>;
    }

    installInstructions() {
        const isIos = () => {
            const userAgent = window.navigator.userAgent.toLowerCase();
            return /iphone|ipad|ipod/.test( userAgent );
        }
        // Detects if device is in standalone mode
        const isInStandaloneModeIos = () => ('standalone' in window.navigator) && (window.navigator.standalone);
         
        if (isIos() && !isInStandaloneModeIos()) {
        return <div>
            <h3>Install this web site as an app</h3><br/>
            <b>iPhone &amp; iPad</b><br/>
            <ul>
            <li>Make sure this page is open in Safari (the default web browser)</li>
            <li>Touch the share icon and choose Add to Home Screen<br/></li>
            </ul>
            <Image1 src={iosShare} className="imageTips" /><br/>
            <Image1 src={iosAdd} className="imageTips" /><br/>
            <Image1 src={iosConfirm} className="imageTips" />
        </div>
        }

        var ua = navigator.userAgent.toLowerCase();
        var isAndroid = ua.indexOf("android") > -1; //&& ua.indexOf("mobile");

        var isInStandaloneAndroid = window.matchMedia('(display-mode: standalone)').matches;
        
        if (isAndroid && !isInStandaloneAndroid) {
            return <div>
                <h3>Install this web site as an app</h3><br/>
                <b>Android</b><br/>
                <ul>
                    <li>Make sure this page is open in Chrome (the default web browser)</li>
                    <li>Touch the overflow button (three vertical dots) and choose Add to Home Screen</li>
                </ul>
                <Image1 src={android1} maxWidth="200px" className="imageTips" /><br/>
                <Image1 src={android2} maxWidth="200px" className="imageTips" />
            </div>
            }
    }
}

export default Home;
