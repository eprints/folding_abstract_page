
/* 
Makes html "details" tags animated, using EPJS_toggleSlideScroll
 */
window.addEventListener("DOMContentLoaded", (event) => {
    let currentId = 0;
    for (let item of this.document.querySelectorAll("details")) {
        const dId = `${currentId}`;

        item.id = `details_${dId}`;

        let content_container_inner = document.createElement("div");
        content_container_inner.id = `details_${dId}_content_inner`;

        let children = Array.from(item.children)
        content_container_inner.replaceChildren(...children.slice(1));        

        let content_container = this.document.createElement("div");
        content_container.id = `details_${dId}_content`;

        if (item.getAttribute("open") == "") {
            content_container.setAttribute("style", "overflow: visible; display: block;")

        } else {
            content_container.setAttribute("style", "overflow: hidden; display: none; height: 0px;")
        }


        content_container.appendChild(content_container_inner);

        item.replaceChildren(children[0], content_container);


        if (item.children.length > 1) {
            let summary = item.children[0];

            summary.addEventListener("click", (event) => {

                event.preventDefault();

                EPJS_toggleSlideScroll(`details_${dId}_content`, false, `details_${dId}`);


                item = document.querySelector(`details#details_${dId}`);
                
                if (item.getAttribute("open") == "") {
                    item.classList.add("closing")
                    window.setTimeout(() => {
                        item.classList.remove("closing")
                        item.removeAttribute("open");
                    }, 300)
                } else {
                    item.setAttribute("open", "");

                }
            })
        }
        currentId += 1;
    }
});