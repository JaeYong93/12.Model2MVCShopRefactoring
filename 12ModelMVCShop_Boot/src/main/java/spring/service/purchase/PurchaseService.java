package spring.service.purchase;

import java.util.Map;

import spring.domain.Purchase;
import spring.domain.Search;



public interface PurchaseService {
	
	public void addPurchase(Purchase purchase) throws Exception;
	
	public Purchase getPurchase(int tranNo) throws Exception;
	
	public Purchase getPurchaseByProd(int prodNo) throws Exception;
	
	public Map<String, Object> getPurchaseList(Search search, String userId) throws Exception;
	
	public Map<String, Object> getSaleList(Search search) throws Exception;
	
	public void updatePurchase(Purchase purchase) throws Exception;
	
	public void updateTranCode(Purchase purchase) throws Exception;
	
}