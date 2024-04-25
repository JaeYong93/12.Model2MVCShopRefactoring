<%@ page language="java" contentType="text/html; charset=EUC-KR"%>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>

<html lang="ko">
<title>��ǰ���</title>
<head>
	<meta charset="EUC-KR">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	
   	<script src="/javascript/bootstrap-dropdownhover.min.js"></script>

	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>	
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

	<script type="text/javascript">

		// �������ø� Event
		$(function() {
			var searchCondition = 0;
		
			if (searchCondition === 0) {
				$("#searchKeyword").autocomplete({
					source: function(request, response) {
						$.ajax({
							url: "/product/json/autoComplete",
							type: "POST",
							dataType: "json",
							headers : {
								"Accept" : "application/json",
								"content-Type": "application/json;charset=euc-kr"
							},
							data: JSON.stringify({ value: request.term }),
							success: function(data) {
								console.log(data)
								response(
									$.map(data.list, function(item) {
										return {
											label: item.PROD_NAME,
											value: item.PROD_NAME
										};
									})
								);
							},  
							error : function() {
								alert("Error �߻�");
							}
						});
					},
					minLength : 1,
					autoFocus : true,
					delay : 200,
					select : function(evt, ui) {
					
					}
				});
			}
		});
	
		// ���ѽ�ũ�� Event	
		var isEnd = false;
		var isLoading = false;
		var currentPage = 2;
		var loadedPages = [];
		//var searchOrderByPrice = $("input[name='searchOrderByPrice']").val();
		
		$(function () {
						
			$(window).scroll(function() {
	           
				if($(window).scrollTop() + $(window).height() > $(document).height() -20){
					if(isEnd || isLoading){
						return;
					}
					loadData();
				}
			});		
		});

		function loadData() {
			if (isEnd || isLoading) {
				return;
			}
			isLoading = true;
			
			var search = {
					"currentPage" : currentPage,
					"searchCondition" : $("select[name='searchCondition']").val(),
					"searchKeyword" : $("#searchKeyword").val(),
 					"searchOrderByPrice" : $("input[name='searchOrderByPrice']").val()
 				}
				console.log(search);
			
					$.ajax({
						url:"/product/json/listProduct",
						method : "POST",
						contentType: 'application/json; charset=euc-kr',
						data : JSON.stringify(search),
						dataType: "json",
						success: function(JSONData) {
						
							currentPage ++;
							search.currentPage=currentPage;
							var length = JSONData.length;
							
							if( length < 5 ) {
								isEnd = true;
							}
							console.log(JSONData);
     						
							for(var i=0 ; i < 4 ; i++){
								var no = (currentPage - 2) * 4 + (i + 1);
								var fileName = JSONData.list[i].fileName;

								$('.row:last').append('<div class="col-sm-4 col-md-3" id="scroll">'
									+'<div class="thumbnail">'
									+'<img src="/images/uploadFiles/'+JSONData.list[i].fileName+'"alt="��ǰ�̹���">'
									+'<div class="caption">'
									+'<h3>No:'+no+'</h3>'
									+'<p>��ǰ��: '+JSONData.list[i].prodName+'</p>'
									+'<p>����: '+JSONData.list[i].price.toLocaleString()+"��"+'</p>'
									+'<p><a href = "#" class="btn btn-default" role="button" data-prodNo='+JSONData.list[i].prodNo+'>����������</a>'
									+'&nbsp;<a href="#" class="btn btn-default" role="button">���ϱ�(������...)</a></p>'
									+'</div>'
									+'</div>'
									+'</div>');
							} 
							
							isLoading = false;
						},
						error : function() {
							console.log("Error �߻�");
							isLoading = false;
						}
					});
				}
		
		// �˻� EVent
		$(function() {
			$( "button.btn.btn-default" ).on("click" , function() {
				sessionStorage.setItem('orderByPrice', "");
				fncGetProductList(1);
			});
			
			// �˻� ���� ��� Event
			$("input[type='text']").keypress(function(event) {
				if(event.which === 13) {
					fncGetProductList(1);
				}
			});
		});		
	
		$(function() {
		    var orderByPrice = sessionStorage.getItem('orderByPrice');
		    if (orderByPrice) {
		        $("input[name='searchOrderByPrice']").val(orderByPrice);
		    }
		});		
		
		$(function() {
			$("#downprice").on("click" , function() {
				$("input[name='searchOrderByPrice']").val(1);
				sessionStorage.setItem('orderByPrice', 1);
				fncGetProductList(1);
			});
		});

		$(function() {
			$("#upprice").on("click" , function() {
				$("input[name='searchOrderByPrice']").val(2);
				sessionStorage.setItem('orderByPrice', 2);
				fncGetProductList(1);
			});
		});            

		// ������ �̵� Event
		function fncGetProductList(currentPage) {
			var menu = "${param.menu}";
			$("#currentPage").val(currentPage);
			$("#menu").val(menu);
			$("form").attr("method", "POST").attr("action", "/product/listProduct").submit();
		}		
		
		// ��ǰ�������� Event		
		$(function() {
			$("a:contains('��ǰ��������')").on("click", function() {
				var prodStr = $(this).data('prodno');
				var prodNo = parseInt(prodStr);
				console.log(prodNo);	
				self.location = "getProduct?prodNo="+prodNo+"&menu=manage";
			});
		});

		// ��ǰ�������� Event	
		$(document).on("click", "a:contains('����������')", function() {
			var prodNo = $(this).data('prodno');
 			console.log(prodNo);
 			self.location = "getProduct?prodNo=" + prodNo + "&menu=search";
		});
			
		// ȸ�������ȸ Event
		$(function() {
			$("a:contains('ȸ�������ȸ')").on("click" , function() {
				self.location = "/user/listUser"
			});
		});
		
		// ����������ȸ Event	
		$(function() {
			$("a[href='#']:contains('����������ȸ')").on("click" , function()  {
				self.location = "/user/getUser?userId=${sessionScope.user.userId}"
			});
		});

		// �ǸŻ�ǰ��� Event
		$(function() {
			$( "a:contains('�ǸŻ�ǰ���')" ).on("click" , function() {
				self.location = "../product/addProductView.jsp"
			});
		});		
	
		// �ǸŻ�ǰ���� Event
		$(function() {
			$( "a:contains('�ǸŻ�ǰ����')" ).on("click" , function() {
				self.location = "/product/listProduct?menu=manage"
			});
		});		
		
		// ��ǰ�˻� Event
		$(function() {
			$("a[href='#' ]:contains('��ǰ�˻�')").on("click" , function()  {
				self.location = "/product/listProduct?menu=search"
			});
		});	
		
		// �����̷���ȸ Event
		$(function() {
			$("a[href='#']:contains('�����̷���ȸ')").on("click" , function() {
				self.location = "/purchase/listPurchase";
			});
		});		
		
		// �ֱٺ���ǰ Event
		$(function() { 
		$( "a:contains('�ֱٺ���ǰ')" ).on("click" , function() {
				$(self.location).attr("href","../history.jsp");
			});
		});	

			
	</script>

	<style>
 		body {
			padding-top : 50px;
		}
		
		.thumbnail {
			width: 280px;
			height: 600px;
		}
        
		.thumbnail img{
			width: 200px;
			height: 400px;
		}
		
        img  {
        	width : 50px;
        	height : 50px;
        }    
        
        th {
			text-align : center;
		}
		
		.caption p:nth-of-type(2) {
			font-weight: bold;
		}		
			
		
	</style>

</head>

<body>

	<jsp:include page="/layout/toolbar.jsp" />
	
	<div class="container">
	
		<div class ="page-header text-info">
			<c:if test="${param.menu != null && param.menu eq 'search'}">
			<h4>��ǰ�����ȸ</h4>
			</c:if>
		</div>
	
		<c:if test="${param.menu != null && param.menu eq 'search'}">
		<div class="row">
			<div class="col-md-3 text-left">
				<p class="text-primary">��ü ${resultPage.totalCount}��, ���� ${resultPage.currentPage}������</p>
		    </div>	

			<div class="col-md-9 text-right">
				<form class="form-inline" name="detailForm">
					<input type = "hidden" id = "menu" name = "menu" value = "">
					<input type = "hidden" id = "currentPage" name = "currentPage" value=""/> 
					<div class="form-group">	
						<button type = "button" class="btn btn-success" name="searchOrderByPrice" id="downprice">���ݳ�������</button>
			    		<button type = "button" class="btn btn-success" name="searchOrderByPrice" id="upprice">���ݿ�������</button>
   							<input type = "hidden" id = "searchOrderByPrice" name = "searchOrderByPrice"/>
						<select class="form-control" name="searchCondition">
							<option value="0" ${! empty search.searchCondition && search.searchCondition==0 ? "selected" : ""}>��ǰ��</option>
							<option value="1" ${! empty search.searchCondition && search.searchCondition==1 ? "selected" : ""}>����</option>
			    		</select>
			    	</div>
			    	
					<div class="form-group">
						<label class="sr-only" for ="searchKeyword">�˻� Ű���带 �Է��ϼ���.</label>
						<input type = "text" class="form-control" id="searchKeyword" name = "searchKeyword" placeholder ="�˻� Ű����"
							value = "${! empty search.searchKeyword ? search.searchKeyword : '' }" autoComplete="on">
					</div>
					
					<button type="button" class="btn btn-default">�˻�</button>
				</form>
			</div>
		</div>
		</c:if>
		<br/><br/>
		
		<c:if test="${param.menu != null && param.menu eq 'search'}">
		<table>
		<tbody>
			<c:set var="i" value="0"/>
			<c:forEach var = "product" items = "${list}" varStatus="loop">
				<c:set var = "i" value = "${i+1}"/>
				<c:if test="${loop.index == 0 || loop.index % 4==0}">
					<div class="row">
				</c:if>			

				<div class="col-sm-4 col-md-3" id="scroll">	
					<div class="thumbnail">					
						<img src="/images/uploadFiles/${product.fileName}" alt="��ǰ�̹���">
						<div class="caption">
							<h3>No: ${i}</h3>
							<p>��ǰ��: ${product.prodName}</p>
							<p>����: <fmt:formatNumber value="${product.price}" pattern = "#,###"/>��</p>
					 			<p><a href = "#" class="btn btn-default" role="button" data-prodNo = "${product.prodNo}">����������</a>
					 				<a href="#" class="btn btn-default" role="button">���ϱ�(������...)</a></p>

						</div>
					</div>
				</div>			
			</c:forEach>
    	</tbody>
    	</table>
    	</c:if>		
		
		<c:if test="${param.menu != null && param.menu eq 'manage'}">
		<div class="row">

			<div class="col-md-3">

				<div class="panel panel-primary">
				
					<div class="panel-heading">
						<i class="glyphicon glyphicon-user"></i> ȸ������
					</div>

					<ul class="list-group">
						<li class="list-group-item">
							<a href="#">����������ȸ</a> 
						</li>
						<c:if test="${sessionScope.user.role == 'admin'}">
						<li class="list-group-item"><a href="#">ȸ�������ȸ</a></li>
						</c:if>
					</ul>
				</div>
				
				<c:if test="${sessionScope.user.role == 'admin'}">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<i class="glyphicon glyphicon-tasks"></i> ��ǰ����
					</div>
					
					<ul class="list-group">
						<li class="list-group-item">
							<a href="#">�ǸŻ�ǰ���</a>
						</li>
						<li class="list-group-item">
							<a href="#">�ǸŻ�ǰ����</a>
						</li>
					</ul>
				</div>
				</c:if>

				<div class="panel panel-primary">
					<div class="panel-heading">
						<i class="glyphicon glyphicon-shopping-cart"></i> ��ǰ����
					</div>
					
					<ul class="list-group">
						<li class="list-group-item">
							<a href="#">��ǰ�˻�</a>
						</li>
						<li class="list-group-item">
							<a href="#">�����̷���ȸ</a>
						</li>
						<li class="list-group-item">
							<a href="#">�ֱٺ���ǰ</a>
						</li>
					</ul>
				</div>
			</div>

			<div class="col-md-9">
			
				<div class="page-header text-left">
					<h4>��ǰ����</h4>
				</div>			

				<div class="col-md-3 text-left">
					<p class="text-primary">��ü ${resultPage.totalCount}��, ���� ${resultPage.currentPage}������</p>
			    </div>	
	
				<div class="col-md-9 text-right">
					<form class="form-inline" name="detailForm">
						<input type = "hidden" id = "menu" name = "menu" value = "">
						<div class="form-group">
												<button type = "button" class="btn btn-success" name="searchOrderByPrice" id="downprice">���ݳ�������</button>
			    		<button type = "button" class="btn btn-success" name="searchOrderByPrice" id="upprice">���ݿ�������</button>
   							<input type = "hidden" id = "searchOrderByPrice" name = "searchOrderByPrice"/>
							<select class="form-control" name="searchCondition">
								<option value="0" ${! empty search.searchCondition && search.searchCondition==1 ? "selected" : ""}>��ǰ��</option>
								<option value="1" ${! empty search.searchCondition && search.searchCondition==2 ? "selected" : ""}>����</option>  		
				    		</select>
				    	</div>
				    	
						<div class="form-group">
							<label class="sr-only" for ="searchKeyword">�˻� Ű���带 �Է��ϼ���.</label>
							<input type = "text" class="form-control" id="searchKeyword" name = "searchKeyword" placeholder ="�˻� Ű����"
								value = "${! empty search.searchKeyword ? search.searchKeyword : '' }" autoComplete="on">
						</div>
						
						<button type="button" class="btn btn-default">�˻�</button>
						<input type = "hidden" id = "currentPage" name = "currentPage" value=""/> 
					</form>
				</div>			
				
				<table class="table table-bordered">
					<thead>
						<tr>
							<th>No</th>
							<th>��ǰ��</th>
							<th>��ǰ�̹���</th>
							<th>����</th>
							<th>�����</th>
							<th>�������</th>
						</tr>
					</thead>
					
					<tbody>
						<c:set var="i" value ="0"/>
						<c:forEach var = "product" items = "${list}">
							<c:set var ="i" value = "${i+1}"/>
							<tr>
								<td align="center">${i}</td>
								<td align="center">${product.prodName}</td>
								<td align="center"><img src="/images/uploadFiles/${product.fileName}" alt="�����ڻ�ǰ�̹���"></td>								 
								<td align="center"><fmt:formatNumber value="${product.price}" pattern = "#,###"/>��</td>
								<td align="center">${product.regDate}</td>
								<td align="left">
								<c:if test = "${empty product.proTranCode}">
									�Ǹ���
								</c:if>
								<c:if test = "${product.proTranCode == '2'}">
									���ſϷ� ����ϱ�
								</c:if>
								<c:if test = "${product.proTranCode != null && product.proTranCode != '2'}">
									�ǸſϷ�
								</c:if>	
								</td>
							</tr>			
						</c:forEach>
					</tbody> 
				</table>	
			</div>	
			<jsp:include page="../common/pageNavigator_new.jsp">	
				<jsp:param name = "listType" value = "product"/>
			</jsp:include>		
		</div>
		</c:if>
	</div>
		
</body>
</html>