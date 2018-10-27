<%@ Page Language="C#" MasterPageFile="~/Viewer/MasterPage/Main.Master" AutoEventWireup="true" CodeBehind="creation.aspx.cs" Inherits="Storichain.WebSite.User.creation" ValidateRequest="false" EnableViewState="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server" EnableViewState="false">
<%--<script src="http://1.237.42.87:8080/app.js"></script>--%>
<script>
    $(function () {
        $("body").addClass("fxbd");

        $("#character_prev, #character_next").click(function () {
            if ($("#ContentPlaceHolder1_characterIdx").val() == "1") {
                $(".wuser_name").text("성춘향");
                $("#characterImg").attr("src", "/images/del/character2.png");
                $("#ContentPlaceHolder1_characterIdx").val("2");
            } else {
                $(".wuser_name").text("이도령");
                $("#characterImg").attr("src", "/images/del/character1.png");
                $("#ContentPlaceHolder1_characterIdx").val("1");
            }
        });

        $("#imgRegistBtn").click(function () {
            $("#ContentPlaceHolder1_fileInfo").click();
        });

        $("#imgUploadBtn").click(function () {
            var imgCnt = $("#dialogueImg > img").length;
            if (imgCnt > 0) {
                var imgSrc = $("#dialogueImg > img").attr("src");
                var str = '<div class="aimg"><img src="' + imgSrc + '" alt="" /><button type="button" class="btn btn_img_del"><span class="blind">이미지 삭제</span></button></div>';
                $("#imgList").html(str);
                $("#imgList").show();
            }
            return false;
        });

        $(document).on("click", ".btn_img_del", function () {
            $("#ContentPlaceHolder1_fileInfo").val("");
            $("#dialogueImg").empty();
            $("#imgList").empty();
            $("#imgList").hide();
        });

        $("button[name='createBtn']").click(function () {
            var descriptionYn = $("#ContentPlaceHolder1_descriptionYn").val();
            if (descriptionYn == "N") {
                var text = $("#ContentPlaceHolder1_ctxt_input").val();
                var fileStr = $("#ContentPlaceHolder1_fileInfo").val();
                if (fileStr == "" && text == "") {
                    alert("텍스트나 이미지를 넣어주세요");
                    $("#ContentPlaceHolder1_ctxt_input").focus();
                    return false;
                }
                // submit
                $("#ContentPlaceHolder1_ibnSubmit1").click();
            } else {
                var text2 = $("#ContentPlaceHolder1_ctxt_input2").val();
                if (text2 == "") {
                    alert("텍스트를 넣어주세요");
                    $("#ContentPlaceHolder1_ctxt_input2").focus();
                    return false;
                }
                // submit
                $("#ContentPlaceHolder1_ibnSubmit2").click();
            }
            

        });
        

        $("#tranBtn").click(function () {
            //App.setDialogue();
            window.open("http://1.237.42.87:8080?dialogue=" + $("#dialog").val(), 'popup01', 'width=300, height=50, scrollbars= 0, toolbar=0, menubar=no');
        });
        
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                var imgTag = '<img src="' + e.target.result + '" alt="" />';
                $("#dialogueImg").html(imgTag);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function initControl() {
        $(".wuser_name").text("이도령");
        $("#characterImg").attr("src", "/images/del/character1.png");
        $("#ContentPlaceHolder1_characterIdx").val("1");
        $("#ContentPlaceHolder1_fileInfo").val("");
        $("#dialogueImg").empty();
        $("#imgList").empty();
        $("#imgList").hide();
    }

    function doGetRenew(response) {
        if (response == null || response.response_data.length == 0) {
            return false;
        }
        var before_character = "";
        //console.info(response.response_data);
        $.each(response.response_data, function (i, value) {
            var character_idx = value.character_idx;
            var description_yn = value.description_yn;
            var creation_text = value.creation_text;
            var file_idx = value.file_idx;
            var file_src = imgUrl(value, "file_idx", "supply");
            if (file_idx == 0) {
                file_src = "";
            }
            if (description_yn == "Y") {
                var str = stringFormat(
                        '<div class="scene">\
				            <div class="ct_wrap">\
					            <div class="scene_txt">\
						            <p>{0}</p>\
					            </div>\
				            </div>\
			            </div>'
                        , creation_text
                    );
                $("#appendBox").append(str);

            } else {

                var str = stringFormat(
                        '<div class="content write_content"><div class="ct_wrap">{0}</div></div>'
                        , getDetail(character_idx, before_character, file_src, creation_text)
                    );
                before_character = character_idx;
                $("#appendBox").append(str);
            }


        });
    }

    function getDetail(character_idx, before_character, file_src, creation_text) {
        var str = "";
        var characterStr = stringFormat(
                '<div class="cmt_user"><img src="/images/del/character1.png" alt="" class="user_pf_img" /><strong class="user_name">이도령</strong></div>'
            );
        if (character_idx == "2") {
            characterStr = stringFormat(
                '<div class="cmt_user"><img src="/images/del/character2.png" alt="" class="user_pf_img" /><strong class="user_name">성춘향</strong></div>'
            );
        }
        if (character_idx == before_character) {
            characterStr = "";
        }
        if(character_idx == "1"){
            str = stringFormat(
            '<div class="cmt cmt_l">\
				{1}\
				<ul class="cmt_lst">\
					<li><span>{0}</span></li>\
				</ul>\
			</div>'
            , (file_src == "") ? creation_text : creation_text + '<div class="wimg"><img src="' + file_src + '" alt="" /></div>'
            , characterStr
            );
        }else{
            str = stringFormat(
            '<div class="cmt cmt_r">\
				{1}\
				<ul class="cmt_lst">\
					<li><span>{0}</span></li>\
				</ul>\
			</div>'
            , (file_src == "") ? creation_text : creation_text + '<div class="wimg"><img src="' + file_src + '" alt="" /></div>'
            , characterStr
            );
        }
        return str;
    }

    function doScrollEnd() {
        $("#appendBox").scrollTop($(document).height() + 3000000);
    }

    function setHidden(dialogue) {
        $("#dialog").val(dialogue);
        //$("#dialIframe").find("#")
    }

    

</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" EnableViewState="false">
<form id="form1" runat="server">
    <div class="header mhd">
    <div class="mhd_lg">
        <div class="hd_wrap">
            <h1 class="logo"><a href="#"><img src="/images/logo_txt.png" alt="" /></a></h1>
			<a href="/feed" class="btn btn_back_w"><span class="blind">뒤로가기</span></a>
            <button type="button" class="btn btn_info"><span class="blind">information</span></button>
        </div>
    </div>

    <div class="hnav_hd">
        <div class="nav_wrap">
            <ul class="hnav">
                <li class="m1"><a href="/discover"><strong>Discover</strong></a></li>
                <li class="m2"><a href="/feed"><strong>Feed</strong></a></li>
                <li class="m3"><a href="/desk"><strong>Desk</strong></a></li>
                <li class="m4"><a href="/cowork"><strong>Cowork</strong></a></li>
            </ul>
        </div>
    </div>
</div>

<!-- information -->
<div class="info_layer">
    <div class="info_hd">
        <h2>Information</h2>
        <button type="button" class="btn btn_close_info"><span class="blind">정보 닫기</span></button>
    </div>
    <div class="info_bd">
        <div class="lagn_sel">
            <button type="button" class="btn btn_lang">Lanugage Selection</button>
            <ul class="lang_list">
                <li><a href="#" class="selected">English</a></li>
                <li><a href="#">Japanese</a></li>
                <li><a href="#">Chinese</a></li>
                <li><a href="#">Spanish</a></li>
                <li><a href="#">French</a></li>
                <li><a href="#">Korean</a></li>
            </ul>
        </div>
        <ul class="info_list">
            <li><a href="#">Official Blog</a></li>
            <li><a href="#"> What is Storchain?</a></li>
            <li><a href="#">User Guide</a></li>
            <li><a href="#">Share to Friends</a></li>
            <li><a href="#">Exchange</a></li>
            <li><a href="#">Buy Token "TORI"</a></li>
            <li><a href="#">Blue Paper</a></li>
            <li><a href="#">White Paper Open API</a></li>
            <li><a href="#">Developer Center</a></li>
        </ul>
        <ul class="info_list">
            <li><a href="#">Privacy Policy</a></li>
            <li><a href="#"> Terms & Conditions</a></li>
        </ul>
    </div>
</div>
<!-- // information -->

<div class="write_wrap">
    <div class="rside">
        <ul class="view_ctrl">
            <li><button type="button" class="btn selected" id="btnr_crt">Creation</button></li>
            <li><button type="button" class="btn selected" id="btnr_plot">Plot</button></li>
            <li><button type="button" class="btn selected" id="btnr_rt">Readers <br />Talk</button></li>
            <li><button type="button" class="btn" id="btnr_st">Storyteller <br />Talk</button></li>
        </ul>
    </div>
    <!-- write -->
    <div class="cbox wfbox">
		<div class="wf_header">
			<h2 class="ptit"><a href="#">Creation(Chat Mode)</a></h2>
			<a href="/feed" class="btn btn_back_w"><span class="blind">뒤로가기</span></a>
			<a href="#" class="btn btn_setting"><span class="blind">설정</span></a>
		</div>
		<div class="cibox" id="appendBox">
			<div class="scene_num">
				<div class="ct_wrap">
					<div class="scene_number">#1</div>
				</div>
			</div>
			
		</div>

        <div class="wrt_inp">
			<button type="button" class="btn_write"><span>STORI 입력</span></button>
			<div class="write_input">
				
					<div class="react_btn_list">
						<ul>
							<li><button type="button" class="btn btn_s btn_cp">더보기</button></li>
							<li><button type="button" class="btn btn_s btn_cp">이도령이 칼을 집는다</button></li>
							<li><button type="button" class="btn btn_s btn_cp">이도령이 물을 마신다</button></li>
							<li><button type="button" class="btn btn_s btn_cp">변사또 눈치본다</button></li>
							<li><button type="button" class="btn btn_s btn_cp">변사또 눈치본다</button></li>
						</ul>
					</div>
					<div class="inp_category">
                        <input type="hidden" id="descriptionYn" name="descriptionYn" value="N" runat="server" />
						<p>Tab to change pragraph</p>
						<ul>
							<li id="btn_dia" class="selected"><strong>Dialogue</strong><span>@</span></li>
							<li id="btn_dep"><strong>Depiction</strong><span>!</span></li>
							<li id="btn_sce"><strong>Scene</strong><span>#</span></li>
							<li id="btn_rea"><strong>Reaction</strong><span>$</span></li>
							<li id="btn_ing"><strong>Ingredients</strong><span>%</span></li>
						</ul>
					</div>
					<div class="inp_cont write_inp_reg">
						<div class="wuser">
							<div class="wuser_name">이도령</div>
							<div class="wuser_img">
                                <input type="hidden" id="characterIdx" value="1" runat="server" />
                                <img src="/images/btn_sp_prev.png" alt="" style="width: 8px;vertical-align: middle;margin-top: 13px;margin-right: 3px;" id="character_prev" />
                                <img src="/images/del/character1.png" alt="" id="characterImg" />
                                <img src="/images/btn_sp_next.png" alt="" style="width: 8px;vertical-align: middle;margin-top: 13px;" id="character_next" />
							</div>
						</div>
						<div class="write_txt"><textarea name="textInput1" id="ctxt_input" runat="server" class="cre_txt" cols="30" rows="10" placeholder="Type text to dialog, Use direction key to change character"></textarea></div>
						<div class="add_iml" style="display:none;" id="imgList">
							<%--<div class="aimg"><img src="/images/del/u.png" alt="" /><button type="button" class="btn btn_img_del"><span class="blind">이미지 삭제</span></button></div>
							<div class="aimg"><img src="/images/del/u.png" alt="" /><button type="button" class="btn btn_img_del"><span class="blind">이미지 삭제</span></button></div>
							<div class="aimg"><img src="/images/del/u.png" alt="" /><button type="button" class="btn btn_img_del"><span class="blind">이미지 삭제</span></button></div>--%>
							<!-- 동영상은 동영상 아이콘에 삭제버튼, 링크의 경우는 링크 아이콘에 삭제버튼을 넣도록 하면 어떨까요? 공간이 부족해서 애매하네요. -->
						</div>
						<button type="button" class="btn btn_s btn_cp btn_create" id="createBtn1" name="createBtn">Create</button>
                        <div style="display:none;">
                            <asp:Button ID="ibnSubmit1" runat="server" style="width:0.1px" OnClick="ibnSubmit1_Click" Text="submit" />
                        </div>
					</div>
					<div class="inp_cont dpt_inp_reg" style="display:none">
						<div class="write_txt"><textarea name="textInput2" id="ctxt_input2" runat="server" class="cre_txt" cols="30" rows="10" placeholder="Depiction"></textarea></div>
						<button type="button" class="btn btn_s btn_cp btn_dcreate" id="createBtn2" name="createBtn">Create</button>
					</div>
					<div class="inp_cont scene_inp_reg" style="display:none">
						<ul class="scn_num">
							<li>
								<div>
									<select name="" id="" class="sel">
										<option value="">#Scene Number</option>
										<option value="">#1</option>
										<option value="">#2</option>
										<option value="">#3</option>
										<option value="">#4</option>
									</select>
								</div>
							</li>
							<li>
								<div>
									<select name="" id="" class="sel">
										<option value="">낮</option>
										<option value="">밤</option>
									</select>
								</div>
							</li>
							<li>
								<div>
									<select name="" id="" class="sel">
										<option value="">실내</option>
										<option value="">실외</option>
									</select>
								</div>
							</li>
						</ul>
						<div class="scene_title"><input type="text" name="" id="scn_tit" class="scn_inp" placeholder="Scene Title" /></div>
						<button type="button" class="btn btn_s btn_cp btn_create">Create</button>
                        <div style="display:none;">
                            <asp:Button ID="ibnSubmit2" runat="server" style="width:0.1px" OnClick="ibnSubmit2_Click" Text="submit" />
                        </div>
					</div>
					<div class="insert_bar">
						<ul>
							<li><button type="button" class="btn btn_ist btn_emt"><span class="blind">이모티콘 등록</span></button></li>
							<li><button type="button" class="btn btn_ist btn_img"><span class="blind">이미지 등록</span></button></li>
							<li><button type="button" class="btn btn_ist btn_mov"><span class="blind">동영상 등록</span></button></li>
							<li><button type="button" class="btn btn_ist btn_lnk"><span class="blind">링크 등록</span></button></li>
						</ul>
						<div class="onoff_txt"><input type="checkbox" id="liveof" class="ofchk"><label for="liveof" class="oflbl"><em></em><span></span></label></div>
						<button type="button" class="btn btn_ptf" id="tranBtn">Publish to Feed</button>
                        <input type="hidden" id="dialog" value="" />
					</div>
			</div>
        </div>
		<button type="button" class="btn btn_plot_open">구성</button>

		<!-- reaction layer -->
		<div class="cbox_in_layer reaction_layer">
			<div class="wf_header">
				<h2 class="ptit">Making Reaction Button</h2>
			</div>
			<div class="h_tab">
				<div class="tab_wrap">
					<ul class="htab htab2">
						<li class="selected"><a href="#">Free Reaction Button</a></li>
						<li><a href="#">Paid Reaction Button</a></li>
					</ul>
				</div>
			</div>
			<div class="wlayer_ct">
				<div class="wlayer_ibox">
						<p class="reaction_desc">* Reaction Button appears at the end of a scene.<br />You may add Reaction Button 0-5 in one scene</p>
						<h2 class="reaction_tit">What Scene to Add this Reaction Button? :</h2>
						<div class="reaction_select">
							<div class="reaction_selected">
								<span class="scene_num">#23</span>
								<span class="scene_tit">Warrios takes the sword andWarrios takes the sword andWarrios takes the sword and</span>
							</div>
							<div class="reaction_open_list">
								<ul>
									<li>
										<span class="scene_num">#1</span>
										<span class="scene_txt">Warrios takes the sword andWarrios takes the sword andWarrios takes the sword and</span>
									</li>
									<li>
										<span class="scene_num">#2</span>
										<span class="scene_txt">Warrios takes the sword andWarrios takes the sword andWarrios takes the sword and</span>
									</li>
									<li>
										<span class="scene_num">#3</span>
										<span class="scene_txt">Warrios takes the sword andWarrios takes the sword andWarrios takes the sword and</span>
									</li>
									<li>
										<span class="scene_num">#4</span>
										<span class="scene_txt">Warrios takes the sword andWarrios takes the sword andWarrios takes the sword and</span>
									</li>
									<li>
										<span class="scene_num">#5</span>
										<span class="scene_txt">Warrios takes the sword andWarrios takes the sword andWarrios takes the sword and</span>
									</li>
								</ul>
							</div>
						</div>

						<ul class="rm_ul">
							<li class="rm_li">
								<div class="reaction_kinda">Kinda<br />More</div>
								<div class="reaction_make">
									<h3 class="form_tit">Name a Reaction Button that Inducing 'see more'</h3>
									<div class="inp_box_bd"><input type="text" name="" id="kmore" class="inpt" /><label for="kmore" class="blind">Name a Reaction Button that Inducing 'see more'</label><button type="button" class="btn btn_s btn_cb">Make</button></div>
									<ul class="rc_list">
										<li class="rc_c1">그래서 다음은?<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
										<li class="rc_c2">와 진짜?<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
										<li class="rc_c3">와 진짜?<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
									</ul>
								</div>
							</li>
							<li class="rm_li">
								<div class="reaction_kinda">Kinda<br />Choice</div>
								<div class="reaction_make">
									<h3 class="form_tit">Name a Reaction Button that Inducing reader to make a choice</h3>
									<div class="inp_box_bd"><input type="text" name="" id="kchoice" class="inpt" /><label for="kchoice" class="blind">Name a Reaction Button that Inducing reader to make a choice</label><button type="button" class="btn btn_s btn_cb">Make</button></div>
									<ul class="rc_list">
										<li class="rc_c1">그래서 다음은?<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
										<li class="rc_c2">와 진짜?<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
										<li class="rc_c3">와 진짜?<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
									</ul>
									<h3 class="form_tit">Scene Number to Move</h3>
									<div class="inp_box_bd w50"><input type="text" name="" id="kchoice" class="inpt" /><label for="kchoice" class="blind">Name a Reaction Button that Inducing reader to make a choice</label><button type="button" class="btn btn_add_sbtn">+선택형 버튼 더 추가</button></div>
								</div>
							</li>
							<li class="rm_li">
								<div class="reaction_kinda">Kinda<br />Link</div>
								<div class="reaction_make">
									<h3 class="form_tit">Naming a Reaction Button that Inducing reader to 'move to another Link'</h3>
									<div class="inp_box_bd"><input type="text" name="" id="klink" class="inpt" /><label for="klink" class="blind">Naming a Reaction Button that Inducing reader to 'move to another Link'</label></div>
									<h3 class="form_tit">UREL to Move Reader</h3>
									<div class="inp_box_bd"><input type="text" name="" id="kurl" class="inpt" placeholder="Http://URL" /><label for="kurl" class="blind">UREL to Move Reader</label><button type="button" class="btn btn_s btn_cb">Make</button></div>
									<ul class="rc_list">
										<li class="rc_c1">이건 공유해야 해<button type="button" class="btn btn_rc_del"><span class="blind">삭제</span></button></li>
									</ul>
								</div>
							</li>
						</ul>

						<div class="form_btn_c">
							<button class="btn btn_s btn_cp">Add Reaction Button into Scene</button>
						</div>
				</div>
			</div>
		   <button type="button" class="btn btn_ly_colse btn_reaction_close">닫기</button>
		</div>
		<!-- // reaction layer -->

		<!-- Ingredients layer -->
		<div class="cbox_in_layer ingredients_layer">
			<div class="wf_header">
				<h2 class="ptit">Stori Ingredients</h2>
			</div>
			<div class="h_tab">
				<div class="tab_wrap">
					<ul class="htab">
						<li class="selected"><a href="#">Cast</a></li>
						<li><a href="#">Emoji</a></li>
						<li><a href="#">Image</a></li>
					</ul>
				</div>
			</div>
			<div class="wlayer_ct">
				<div class="wlayer_ibox">
						<div class="char_reg">
							<div class="char_reg_img_area">
								<div class="char_img">
									<div class="char_img_r"><img src="/images/del/u.png" alt="" /></div>
									<button type="button" class="btn btn_img_reg"><span class="blind">사진등록</span></button>
									<!-- 삭제버튼. 아니면 등록버튼을 눌렀을때 기본이미지로 갈것인지 사진등록을 할것인지를 레이어로 넣어서 선택하게 하는건 어떨까요??
										<button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
									-->
								</div>
								<div class="form_box">
									<div class="inp_box"><input type="text" name="" id="cname" class="inpt" placeholder="type character's name" /><label for="wname" class="lblt">type character's name</label></div>
									<p class="error_msg">error_msg</p>
								</div>
							</div>
							<ul class="form_btn form_btn1">
								<li><span><button class="btn_r btn_l btn_cb">Register character</button></span></li>
							</ul>
						</div>
						<h2 class="ct_tit">등록된 캐릭터 자원 리스트</h2>
						<div class="ctable">
							<table class="c_table">
								<caption><span class="blind">등록된 캐릭터 자원 리스트</span></caption>
								<colgroup>
								<col width="39%">
								<col width="37%">
								<col width="24%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">character name</th>
										<th scope="col">place to show</th>
										<th scope="col">casting</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="tal">
											<div class="character_name">
												<span class="cimg"><img src="/images/del/u.png" alt="" /></span>
												<strong class="cname">David</strong>
											</div>
										</td>
										<td>
											<div class="pts">
												<span class="dfrdo_bx"><input type="radio" id="pts1_l" name="pts1" value="" class="dfrdo" checked="checked"><label for="pts1_l" class="dfrdo_lb">left</label></span>
												<span class="dfrdo_bx"><input type="radio" id="pts1_r" name="pts1" value="" class="dfrdo"><label for="pts1_r" class="dfrdo_lb">right</label></span>
											</div>
										</td>
										<td>
											<div class="casting_btn"><button class="btn btn_s btn_cp">casting</button></div>
										</td>
									</tr>
									<tr>
										<td class="tal">
											<div class="character_name">
												<span class="cimg"><img src="/images/del/u.png" alt="" /></span>
												<strong class="cname">David</strong>
											</div>
										</td>
										<td>
											<div class="pts">
												<span class="dfrdo_bx"><input type="radio" id="pts2_l" name="pts2" value="" class="dfrdo" checked="checked"><label for="pts2_l" class="dfrdo_lb">left</label></span>
												<span class="dfrdo_bx"><input type="radio" id="pts2_r" name="pts2" value="" class="dfrdo"><label for="pts2_r" class="dfrdo_lb">right</label></span>
											</div>
										</td>
										<td>
											<div class="casting_btn"><button class="btn btn_s btn_cp">casting</button></div>
										</td>
									</tr>
									<tr>
										<td class="tal">
											<div class="character_name">
												<span class="cimg"><img src="/images/del/u.png" alt="" /></span>
												<strong class="cname">David</strong>
											</div>
										</td>
										<td>
											<div class="pts">
												<span class="dfrdo_bx"><input type="radio" id="pts3_l" name="pts3" value="" class="dfrdo" checked="checked"><label for="pts3_l" class="dfrdo_lb">left</label></span>
												<span class="dfrdo_bx"><input type="radio" id="pts3_r" name="pts3" value="" class="dfrdo"><label for="pts3_r" class="dfrdo_lb">right</label></span>
											</div>
										</td>
										<td>
											<div class="casting_btn"><button class="btn btn_s btn_gr">off</button></div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
				</div>
			</div>
		   <button type="button" class="btn btn_ly_colse btn_ingredients_close">닫기</button>
		</div>
		<!-- // Ingredients layer -->

    </div>
    <!-- write -->

    <!-- plot -->
    <div class="pbox wfbox">
		<div class="wf_header">
			<h2 class="ptit"><a href="#">Plot</a></h2>
			<a href="#" class="btn btn_setting"><span class="blind">설정</span></a>
		</div>
		<div class="pibox">
				<div class="plot_hd">
					<h2 class="plot_tit">Plot Story</h2>
					<div class="plot_btn"><button type="button" class="btn btn_s btn_add_plot">Plot Templates +</button></div>
					<div class="form_box">
						<h3 class="form_tit">Main Character's Deep Desire</h3>
						<div class="inp_box"><input type="text" name="" id="deep_desire" class="inpt" /><label for="deep_desire" class="lblt">Main Charactore's Deep Desire</label></div>
						<p class="error_msg">error_msg</p>
					</div>
					<div class="form_box">
						<h3 class="form_tit">Main Character's Exterior Desire</h3>
						<div class="inp_box"><input type="text" name="" id="exterior_Desire" class="inpt" /><label for="exterior_Desire" class="lblt">Main Character's Exterior Desire</label></div>
						<p class="error_msg">error_msg</p>
					</div>
					<div class="plot_btn"><button type="button" class="btn btn_s btn_y btn_make_plot">Make_plot Inputs +</button></div>
				</div>
				<div class="plot_bd">
					<ul class="act_list">
						<li>
							<button type="button" class="btn btn_act btn_act_open"><span>ACT1</span><em class="arr"></em></button>
							<div class="scene_ct" style="display:block">
								<ul class="scene_list">
									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #1</h3>
											<div class="inp_box"><input type="text" name="" id="act1_scene1" class="inpt" placeholder="type scene name &amp; summary" /><label for="act1_scene1" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>
									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #2</h3>
											<div class="inp_box"><input type="text" name="" id="act1_scene2" class="inpt" placeholder="type scene name &amp; summary" /><label for="act1_scene2" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>

									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #2</h3>
											<div class="inp_box"><input type="text" name="" id="act1_scene2" class="inpt" placeholder="type scene name &amp; summary" /><label for="act1_scene2" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>
								</ul>
								<div class="plot_btn"><button type="button" class="btn btn_s btn_y btn_make_plot">Make_plot Inputs +</button></div>
							</div>
						</li>
						<li>
							<button type="button" class="btn btn_act"><span>ACT2</span><em class="arr"></em></button>
							<div class="scene_ct">
								<ul class="scene_list">
									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #1</h3>
											<div class="inp_box"><input type="text" name="" id="act2_scene1" class="inpt" placeholder="type scene name &amp; summary" /><label for="act2_scene1" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>
									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #2</h3>
											<div class="inp_box"><input type="text" name="" id="act2_scene2" class="inpt" placeholder="type scene name &amp; summary" /><label for="act2_scene2" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>

									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #2</h3>
											<div class="inp_box"><input type="text" name="" id="act2_scene2" class="inpt" placeholder="type scene name &amp; summary" /><label for="act2_scene2" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>
								</ul>
								<div class="plot_btn"><button type="button" class="btn btn_s btn_y btn_make_plot">Make_plot Inputs +</button></div>
							</div>
						</li>
						<li>
							<button type="button" class="btn btn_act"><span>ACT3</span><em class="arr"></em></button>
							<div class="scene_ct">
								<ul class="scene_list">
									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #1</h3>
											<div class="inp_box"><input type="text" name="" id="act3_scene1" class="inpt" placeholder="type scene name &amp; summary" /><label for="act3_scene1" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>
									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #2</h3>
											<div class="inp_box"><input type="text" name="" id="act3_scene2" class="inpt" placeholder="type scene name &amp; summary" /><label for="act3_scene2" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>

									<li>
										<div class="form_box">
											<h3 class="form_tit">Scene #2</h3>
											<div class="inp_box"><input type="text" name="" id="act3_scene2" class="inpt" placeholder="type scene name &amp; summary" /><label for="act3_scene2" class="lblt">Scene #1</label></div>
											<p class="error_msg">error_msg</p>
										</div>
									</li>
								</ul>
								<div class="plot_btn"><button type="button" class="btn btn_s btn_y btn_make_plot">Make_plot Inputs +</button></div>
							</div>
						</li>
					</ul>
				</div>
				<ul class="form_btn form_btn1">
					<li><span><button class="btn_r btn_l btn_cp">Save</button></span></li>
				</ul>
		</div>
        <button type="button" class="btn btn_ly_colse btn_plot_close">닫기</button>
    </div>
    <!-- // plot -->

    <!-- talk -->
    <div class="tkbox wfbox">
		<div class="wf_header">
			<h1 class="ptit"><a href="#">Readers Talk</a></h1>
			<a href="#" class="btn btn_setting"><span class="blind">설정</span></a>
		</div>
		<div class="tibox">
			<div class="talk_content">
				<div class="tmt tmt_l">
					<div class="tmt_user"><img src="/images/del/u.png" alt="" class="user_pf_img" /><strong class="user_name">방자</strong></div>
					<ul class="tmt_lst">
						<li><span class="by">샘플텍스트 입니다.</span></li>
						<li><span class="by">샘플텍스트 입니다. 샘플텍스트 입니다. 샘플텍스트 입니다.</span></li>
						<li><span class="by">샘플텍스트 입니다.</span></li>
					</ul>
				</div>
				<div class="tmt tmt_r">
					<div class="tmt_user"><img src="/images/del/u.png" alt="" class="user_pf_img" /><strong class="user_name">방자</strong></div>
					<ul class="tmt_lst">
						<li><span class="bw">샘플텍스트 입니다.샘플텍스트 입니다.샘플텍스트 입니다.샘플텍스트 입니다.</span></li>
						<li><span class="bw">샘플텍스트 입니다.</span></li>
						<li><span class="bw">샘플텍스트 입니다.</span></li>
					</ul>
				</div>
				<div class="tmt tmt_l">
					<div class="tmt_user"><img src="/images/del/u.png" alt="" class="user_pf_img" /><strong class="user_name">방자</strong></div>
					<ul class="tmt_lst">
						<li><span class="bp">샘플텍스트 입니다.</span></li>
						<li><span class="bp">샘플텍스트 입니다. 샘플텍스트 입니다. 샘플텍스트 입니다.</span></li>
						<li><span class="bp">샘플텍스트 입니다.</span></li>
					</ul>
				</div>
				<div class="tmt tmt_l">
					<div class="tmt_user"><img src="/images/del/u.png" alt="" class="user_pf_img" /><strong class="user_name">방자</strong></div>
					<ul class="tmt_lst">
						<li><span class="by">샘플텍스트 입니다.</span></li>
						<li><span class="by">샘플텍스트 입니다. 샘플텍스트 입니다. 샘플텍스트 입니다.</span></li>
						<li><span class="by">샘플텍스트 입니다.</span></li>
					</ul>
				</div>
				<div class="tmt tmt_r">
					<div class="tmt_user"><img src="/images/del/u.png" alt="" class="user_pf_img" /><strong class="user_name">방자</strong></div>
					<ul class="tmt_lst">
						<li><span class="bw">샘플텍스트 입니다.샘플텍스트 입니다.샘플텍스트 입니다.샘플텍스트 입니다.</span></li>
						<li><span class="bw">샘플텍스트 입니다.</span></li>
						<li><span class="bw">샘플텍스트 입니다.</span></li>
					</ul>
				</div>
				<div class="tmt tmt_l">
					<div class="tmt_user"><img src="/images/del/u.png" alt="" class="user_pf_img" /><strong class="user_name">방자</strong></div>
					<ul class="tmt_lst">
						<li><span class="bp">샘플텍스트 입니다.</span></li>
						<li><span class="bp">샘플텍스트 입니다. 샘플텍스트 입니다. 샘플텍스트 입니다.</span></li>
						<li><span class="bp">샘플텍스트 입니다.</span></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="talk_inp">
			<div class="talk_txt">
				<textarea name="" id="ctxt_input_ogigin" class="ctxt" cols="30" rows="10" placeholder="Talk"></textarea>
			</div>
			<button type="button" class="btn btn_s btn_talk">Talk</button>
		</div>
        <button type="button" class="btn btn_ly_colse btn_talk_close">닫기</button>
    </div>
    <!-- // talk -->
</div>

<!-- 팝업 배경 화면 -->
<div class="black_scrn"></div>
<div class="popup updata_popup" id="imgup_popup" style="display:none">
	<div class="popup_wrap">
		<h3 class="popup_tit">이미지 등록</h3>
		<div class="popup_ct">
			<div class="upload_img" style="width:120px;">
				<ul>
					<li>
                        <div class="up_img_r" id="dialogueImg"></div>
						<%--<div class="up_img_r"><img src="/images/del/u.png" alt="" /></div>--%>
						<button type="button" class="btn btn_img_reg" id="imgRegistBtn"><span class="blind">사진등록</span></button>
                        <%--<input type="file" id="fileInfo" style="width:0.1px;height:0.1px;" onchange="readURL(this);" />--%>
                        <asp:FileUpload ID="fileInfo" runat="server" style="width:0.1px;height:0.1px;" onchange="readURL(this);" />
						<!-- <button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
						-->
					</li>
					<%--<li>
						<div class="up_img_r"></div>
						<button type="button" class="btn btn_img_reg"><span class="blind">사진등록</span></button>
						<!-- <button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
						-->
					</li>
					<li>
						<div class="up_img_r"></div>
						<button type="button" class="btn btn_img_reg"><span class="blind">사진등록</span></button>
						<!-- <button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
						-->
					</li>--%>
				</ul>

			</div>
		</div>
		<ul class="popup_btn popup_btn1">
			<li><span><button class="btn_r btn_m btn_cp btn_popup_close" id="imgUploadBtn">확인</button></span></li>
		</ul>
	</div>
</div>

<div class="popup updata_popup" id="imgup_popup" style="display:none">
	<div class="popup_wrap">
		<h3 class="popup_tit">이미지 등록</h3>
		<div class="popup_ct">
			<div class="upload_img">
				<ul>
					<li>
						<div class="up_img_r"><img src="/images/del/u.png" alt="" /></div>
						<button type="button" class="btn btn_img_reg"><span class="blind">사진등록</span></button>
						<!-- <button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
						-->
					</li>
					<li>
						<div class="up_img_r"></div>
						<button type="button" class="btn btn_img_reg"><span class="blind">사진등록</span></button>
						<!-- <button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
						-->
					</li>
					<li>
						<div class="up_img_r"></div>
						<button type="button" class="btn btn_img_reg"><span class="blind">사진등록</span></button>
						<!-- <button type="button" class="btn btn_img_del"><span class="blind">사진삭제</span></button>
						-->
					</li>
				</ul>

			</div>
		</div>
		<ul class="popup_btn popup_btn1">
			<li><span><button class="btn_r btn_m btn_cp btn_popup_close">확인</button></span></li>
		</ul>
	</div>
</div>

<div class="popup updata_popup" id="movup_popup" style="display:none">
	<div class="popup_wrap">
		<h3 class="popup_tit">동영상 등록</h3>
		<div class="popup_ct">
			<div class="upload_inp">
				<input type="text" class="inpt" placeholder="동영상 주소를 등록해주세요" />
			</div>
		</div>
		<ul class="popup_btn popup_btn1">
			<li><span><button class="btn_r btn_m btn_cp btn_popup_close">확인</button></span></li>
		</ul>
	</div>
</div>

<div class="popup updata_popup" id="link_popup" style="display:none">
	<div class="popup_wrap">
		<h3 class="popup_tit">링크주소 등록</h3>
		<div class="popup_ct">
			<div class="upload_inp">
				<input type="text" class="inpt" placeholder="링크주소를 등록해주세요" />
			</div>
		</div>
		<ul class="popup_btn popup_btn1">
			<li><span><button class="btn_r btn_m btn_cp btn_popup_close">확인</button></span></li>
		</ul>
	</div>
</div>
</form>

<script type="text/javascript">
	$(function() {
		/* Stori 입력 영역 */
		$('.btn_write').on('click',function(){
			if ($(this).hasClass('show_write_layer')){
				$(this).removeClass('show_write_layer');
				$('.cbox').removeClass('wct_open');
				$('.write_input').removeClass('write_input_show');
			} else {
				$(this).addClass('show_write_layer');
				$('.cbox').addClass('wct_open');
				$('.write_input').addClass('write_input_show');
			}
		});

		$(".content").click(function () {
		    if ($('.btn_write').hasClass('show_write_layer')) {
		        $(this).removeClass('show_write_layer');
		        $('.cbox').removeClass('wct_open');
		        $('.write_input').removeClass('write_input_show');
		    }
		});

		$('.btn_act').on('click',function(){
			if ($(this).hasClass('btn_act_open')){
				$(this).removeClass('btn_act_open');
				$(this).parent('li').find('.scene_ct').hide();
			} else {
				$(this).addClass('btn_act_open');
				$(this).parent('li').find('.scene_ct').show();
			}
		});

		$('#btn_dia').on('click',function(){
			$('.inp_category').find('li').removeClass('selected');
			$(this).addClass('selected');
			$('.inp_cont').hide();
			$('.write_inp_reg').show();
			$("#ContentPlaceHolder1_descriptionYn").val("N");
		});

		$('#btn_dep').on('click',function(){
			$('.inp_category').find('li').removeClass('selected');
			$(this).addClass('selected');
			$('.inp_cont').hide();
			$('.dpt_inp_reg').show();
			$("#ContentPlaceHolder1_descriptionYn").val("Y");
		});

		$('#btn_sce').on('click',function(){
			$('.inp_category').find('li').removeClass('selected');
			$(this).addClass('selected');
			$('.inp_cont').hide();
			$('.scene_inp_reg').show();
		});

		$('.btn_plot_open, #btnr_plot').on('click',function(){
			$('#btnr_plot').addClass('selected');
			$('.pbox').show();
		});

		$('.btn_plot_close').on('click',function(){
			$('.pbox').hide();
			$('#btnr_plot').removeClass('selected');
		});

		$('#btnr_rt').on('click',function(){
			$('#btnr_st').removeClass('selected');
			$('#btnr_rt').addClass('selected');
			$('.tkbox').show();
		});

		$('#btnr_st').on('click',function(){
			$('#btnr_rt').removeClass('selected');
			$('#btnr_st').addClass('selected');
			$('.tkbox').show();
		});

		$('.btn_talk_close').on('click',function(){
			$('.tkbox').hide();
			$('#btnr_rt, #btnr_st').removeClass('selected');
		});

		$('.btn_rea').on('click',function(){
			//$('.pbox').show();
		});

		$('.btn_ing').on('click',function(){
			//$('.pbox').show();
		});

		$('.reaction_selected').on('click',function(){
			if ($(this).hasClass('show_layer')){
				$(this).removeClass('show_layer');
				$('.reaction_open_list').hide();
			} else {
				$(this).addClass('show_layer');
				$('.reaction_open_list').show();
			}
		});


		$('#btn_rea').on('click',function(){
			$('.reaction_layer').show();
		});

		$('.btn_reaction_close').on('click',function(){
			$('.reaction_layer').hide();
		});

		$('#btn_ing').on('click',function(){
			$('.ingredients_layer').show();
		});

		$('.btn_ingredients_close').on('click',function(){
			$('.ingredients_layer').hide();
		});

		$('.btn_img').on('click',function(){
			$('#imgup_popup').show();
			$('.black_scrn').addClass('active');
		});

		$('.btn_mov').on('click',function(){
			$('#movup_popup').show();
			$('.black_scrn').addClass('active');
		});

		$('.btn_lnk').on('click',function(){
			$('#link_popup').show();
			$('.black_scrn').addClass('active');
		});

		$('.btn_popup_close').on('click',function(){
		   $(this).parents('.popup').hide();
			$('.black_scrn').removeClass('active');
		});

	});

	var imgUrl = function (item_data, column_name, key, default_image_path) {

	    if (!item_data.hasOwnProperty(column_name + '_image_count'))
	        return '/Images/etc/product_blank.jpg';
	    if (!item_data.hasOwnProperty(column_name + '_images'))
	        return '/Images/etc/product_blank.jpg';

	    if (Number(item_data[column_name + '_image_count']) > 0) {
	        var img_data = item_data[column_name + '_images'];

	        if (key == null)
	            return img_data[0].image_url;

	        for (i = 0; i < img_data.length; i++) {
	            var item_img_data = img_data[i];

	            if (item_img_data.image_key == key)
	                return item_img_data.image_url;
	        }

	        return img_data[0].image_url;
	    }

	    if (default_image_path != null)
	        return default_image_path;

	    if (column_name == "user")
	        return '/Images/etc/user_blank_s.jpg';
	    else if (column_name == "comment")
	        return '';
	    else if (column_name == "product" || column_name == "product_small" || column_name == "product_thumb")
	        return '/Images/etc/product_blank.jpg';

	    return '';

	    //return "";
	};

	var stringFormat = function (str, col) {

	    col = typeof col === 'object' ? col : Array.prototype.slice.call(arguments, 1);

	    return str.replace(/\{\{|\}\}|\{(\w+)\}/g, function (m, n) {
	        if (m == "{{") { return "{"; }
	        if (m == "}}") { return "}"; }

	        return col[n];
	    });
	};

</script>
<asp:literal id="ltrScript" runat="server"></asp:literal>
<%--<div style="width:0.1px;height:0.1px"><iframe id="dialIframe" src="http://1.237.42.87:8080/index.html" frameborder="0" allowfullscreen="" style="width:0.1px;height:0.1px;"></iframe></div>--%>
</asp:Content>