import React, { Component } from "react";
import ReactGA from 'react-ga';

import Image1 from "./Image1";
import mezzanine from "./assets/Philadelphia201SalonIndependenceLevel.png";
import ballroom from  "./assets/Philadelphia201BallroomLevel.png";

class FloorPlan extends Component {
    render() {
        ReactGA.set({ "page": "Floor Plan"});
        ReactGA.pageview("/FloorPlan");
        return (
            <div>
                <div className="suggestLandscape"><i className="fas fa-sync"></i> This page looks better in landscape <i className="fas fa-sync"></i></div>
                <h2>Mezzanine</h2>
                <Image1 src={mezzanine} maxWidth="600px"/>
                <hr/>
                <h2>Ballroom</h2>
                <Image1 src={ballroom} maxWidth="500px"/>
                <hr /></div>
        );
    }
}
export default FloorPlan;
