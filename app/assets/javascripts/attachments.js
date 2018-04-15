$(document).ready(function(){
    var current_attachment_order;

    $(".attachment").on("click", function (e) {
        $("#attachment-dialog .modal-body").load($(this).data("url"));
        $("#attachment-dialog .modal-title").text($(this).data("title"));
        $("#attachment-dialog").modal('show');
        current_attachment_order = parseInt($(this).data("order"));

    });

    // 模态框隐藏时删除内容， 防止视频继续播放
    $('#attachment-dialog').on('hidden.bs.modal', function (e) {
        $("#attachment-dialog .modal-body").text("loading");
        current_attachment_order = undefined;
    });

    $("#attachment-dialog").on("keydown", function(e){
        console.log(e.key)
        if(e.key == "ArrowLeft") {
            if(current_attachment_order != undefined && current_attachment_order > 0) {
                current_attachment_order = current_attachment_order - 1;
                showOrderAttachment(current_attachment_order);
            }
        }

        if (e.key == "ArrowRight") {
            if (current_attachment_order != undefined && current_attachment_order < $(".attachment").size()) {
                current_attachment_order = current_attachment_order + 1;
                showOrderAttachment(current_attachment_order);
            }
        }
    });

    function showOrderAttachment(order) {
        var $attachment = $(".attachment[data-order=" + order + "]");
        var attachment_url = $attachment .data("url");
        var attachment_title = $attachment .data("title");

        if (attachment_url != undefined) {
            $("#attachment-dialog .modal-body").load(attachment_url);
            $("#attachment-dialog .modal-title").text(attachment_title);
        }
    }

});