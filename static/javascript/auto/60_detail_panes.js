
/* Converts panels to detail panes. The first pane is default open, the rest closed */
addEventListener("DOMContentLoaded", () => {
    let count = 0;
    document.querySelectorAll(".ep_summary_content_main > .ep_panel_container > .ep_panels > .ep_panel_wrapper")
    .forEach(element => {
        let title = element.querySelector(".ep_panel_title");
        title.parentNode.removeChild(title);

        let details = document.createElement("details");
        let content = element.firstElementChild;

        //details.innerHTML = element.innerHTML;
        details.className = element.className;
        //setAttribute("role", element.getAttribute("role"));
        if (count == 0) {
            details.setAttribute("open", "");
        };
        count ++;

        element.parentNode.replaceChild(details, element);

        let summary = document.createElement("summary")
        let heading = document.createElement("h2");

        heading.innerHTML = title.innerHTML;

        summary.setAttribute("aria-controls", content.id);


        
        summary.appendChild(heading);

        details.appendChild(summary);
        details.appendChild(content);

        details.querySelectorAll("[role=tab]").forEach((div) => {
            div.removeAttribute("role");
            
            div.removeAttribute("aria-controls");            
        })

    });
})

console.log("hi!")