package spring.service.user;

import java.util.Map;

import spring.domain.Search;
import spring.domain.User;


//==> ȸ���������� ������ ���� �߻�ȭ/ĸ��ȭ�� Service  Interface Definition  
public interface UserService {
	
	// ȸ������
	public void addUser(User user) throws Exception;
	
	// ������Ȯ�� / �α���
	public User getUser(String userId) throws Exception;
	
	// ȸ����������Ʈ 
	public Map<String , Object> getUserList(Search search) throws Exception;
	
	// ȸ����������
	public void updateUser(User user) throws Exception;
	
	// ȸ�� ID �ߺ� Ȯ��
	public boolean checkDuplication(String userId) throws Exception;
	
}