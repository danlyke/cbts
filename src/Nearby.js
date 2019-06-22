import React, { Component } from "react";
import ReactGA from 'react-ga';

class Nearby extends Component {
    render() {
        ReactGA.set({ "page": "nearby"});
        ReactGA.pageview("/Nearby");
        return (
            <div>
                <h2>This May Or May Not Get Updated</h2>
                <ul>
                    <li>just a placeholder</li>
                </ul>
            </div>
        );
    }
}
export default Nearby;
