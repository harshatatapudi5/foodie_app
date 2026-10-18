package com.tap.util;

import java.util.List;

import com.tap.DAOImp.DAOImp;
import com.tap.DAOImp.OItemDAOImp;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.model.MenuData;
import com.tap.model.OrderItem;
import com.tap.model.OrdersDetails;

//import java.sql.Timestamp;
//import java.util.ArrayList;
//import java.util.List;
import java.util.Scanner;
//
//import com.tap.menu.MenuData;
//
import com.tap.DAOImp.UserDAOImp;
//import com.tap.MenuDAOImp.DAOImp;
//import com.tap.Orders.OrdersDetails;
//import com.tap.ResDAOImp.DAOImpRes;
import com.tap.model.User;
//import com.tap.orderItem.OrderItem;
//import com.tap.orderItemDAOImp.OItemDAOImp;
//import com.tap.resModel.ResDetails;
//import com.tap.OrdersImp.*;

public class App {

	public static void main(String[] args) {
		Scanner sc=new Scanner(System.in);
//		User user=new User("Gupta","Gupta@gmail.com","Gupta123","Nadhi Hills","Customer");
//		UserDAOImp u=new UserDAOImp();
//		u.addUser(user);
		
//		Scanner sc=new Scanner(System.in);
//		
		
		
		
//		UserDAOImp u=new UserDAOImp();
//		User u1=u.getUser(1);
//		System.out.print(u1);
		
		
//		UserDAOImp u=new UserDAOImp();
//		User user=new User();
//		u.updateUser(user);
		
		
//		UserDAOImp u=new UserDAOImp();
//		u.deleteUser(v);
		
		
//	
		
		
		
//		UserDAOImp udo=new UserDAOImp();
//		List<User> users=udo.getAllUser();
//		for(User u1:users) {
//			System.out.println(u1);
//		
//		}
		
		
		
//		System.out.println("Enter res name");
//		String name=sc.nextLine();
//		
//		System.out.println("Enter res type");
//		String cuisine=sc.nextLine();
//		
//		System.out.println("Enter res adddress");
		
//		String address=sc.nextLine();
//		
//		System.out.println("Enter id");
//		int id=sc.nextInt();
//		
//		System.out.println("Enter rating");
//		double rating=sc.nextDouble();
////		
//		ResDetails det=new ResDetails(name,cuisine,address,id,rating);
//		User user=new User(id);
//		DAOImpRes ob=new DAOImpRes();
//		ob.addRes(det,user);
		
//		System.out.println("Enter id");
//		int id=sc.nextInt();
		
		
//		DAOImpRes imp=new DAOImpRes();
//		ResDetails res=imp.getRes(id);
//		System.out.print(res);
		
//		ResDetails res=new ResDetails();
//		DAOImpRes det=new DAOImpRes();
//		det.updateRes(res);
		
//		System.out.println("Enter id");
//		int id=sc.nextInt();
//		DAOImpRes det=new DAOImpRes();
//		det.deleteRes(id);
		
//		DAOImpRes all=new DAOImpRes();
//		List<ResDetails> li=all.getAllRes();
//		for(ResDetails data:li) {
//			System.out.println(data);
//		}
		
		
		
		
//		int r_id=sc.nextInt();
//		sc.nextLine();
//		String item=sc.nextLine();
//		String desc=sc.nextLine();
//		double price=sc.nextDouble();
//		sc.nextLine();
//		String IsAva=sc.nextLine();
//		String cate=sc.nextLine();
		
		
//		DAOImp d=new DAOImp();
//		MenuData m=new MenuData(r_id,item,desc,price,IsAva,cate);
//		ResDetails res=new ResDetails(r_id);
//		d.addMenu(m,res);
		
		
		
//		int id=sc.nextInt();
//		DAOImp d=new DAOImp();
//		MenuData m=d.getMenu(id);
//		System.out.print(m);
		
		
//		MenuData m=new MenuData();
//		DAOImp d=new DAOImp();
//		d.updateMenu(m);
		
		
//		int id=sc.nextInt();
//		DAOImp d=new DAOImp();
//		d.deleteMenu(id);
		
//		DAOImp d=new DAOImp();
//		List<MenuData> li=d.getAllMenu();
//		for(MenuData data:li) {
//			System.out.println(data);
//		}
		
		
		
//		int id=sc.nextInt();
//		int res_id=sc.nextInt();
//		double amount=sc.nextDouble();
//		sc.nextLine();
//		String status=sc.nextLine();
//		String payment=sc.nextLine();
//
//		
//		
//		
//		OrdersDAOImpl od=new OrdersDAOImpl();
//		OrdersDetails o=new OrdersDetails(id,res_id,amount,status,payment);
//		User u=new User(id);
//		ResDetails r=new ResDetails(res_id);
//		od.addOrders(o, u, r);
		
//		System.out.println("Enter id");
//		int id=sc.nextInt();
//		
//		OrdersDAOImpl od=new OrdersDAOImpl();
//		OrdersDetails o=od.getOrder(id);
//		System.out.print(o);
		
//		System.out.println("Enetr amount");
//		double am=sc.nextDouble();
//		System.out.println("Enetr id");
//		
//		int id=sc.nextInt();
//		
//		OrdersDAOImpl od=new OrdersDAOImpl();
//		OrdersDetails o=new OrdersDetails(am,id);
//		od.updateOrders(o);
		
//		System.out.println("Enter id for deleting");
//		int id=sc.nextInt();
//		
//		OrdersDAOImpl od=new OrdersDAOImpl();
//		od.deleteOrders(id);
		
		
//		OrdersDAOImpl od=new OrdersDAOImpl();
//		List<OrdersDetails> li=od.getAllOrders();
//		for(OrdersDetails d:li) {
//			System.out.println(d);
//		}
		
//		int o_id=sc.nextInt();
//		int m_id=sc.nextInt();
//		int quantity=sc.nextInt();
//		double total=sc.nextDouble();
//		
//		
//		
//		
//		OrderItem oItem=new OrderItem(o_id,m_id,quantity,total);
//		OrdersDetails od=new OrdersDetails(o_id);
//		MenuData md=new MenuData(m_id);
//		OItemDAOImp oi=new OItemDAOImp();
//		oi.addOrderItem(oItem, od, md);
		
		
		
//		int id=sc.nextInt();
//		OrderItem oItem=new OrderItem();
//		OItemDAOImp oi=new OItemDAOImp();
//		oItem=oi.getOI(id);
//		System.out.print(oItem);
		
//		int qun=sc.nextInt();
//		int id=sc.nextInt();
//		
//		OItemDAOImp oi=new OItemDAOImp();
//		OrderItem oItem=new OrderItem(qun,id);
//		oi.updateOI(oItem);
		
		
//		int id=sc.nextInt();
//		
//		OItemDAOImp oi=new OItemDAOImp();
//		oi.deleteOI(id);
		
		
//		OItemDAOImp oi=new OItemDAOImp();
//		List<OrderItem> all=oi.getAllOI();
//		for(OrderItem OItem:all) {
//			System.out.println(OItem);
//		}
		
	
		
//		DAOImp menu=new DAOImp();
//		List<MenuData> md=menu.getMenuByRestaurant(v);
//		for(MenuData all:md) {
//			System.out.println(all);
//		}
//		int v=sc.nextInt();
//		
//		OrdersDAOImpl od = new OrdersDAOImpl();
//
//        List<OrdersDetails> li = od.getOrdersByUser(v);
//
//        for (OrdersDetails o : li) {
//            System.out.println(o);
//        }
		
		
//		int v = sc.nextInt();
//
//		OItemDAOImp oi = new OItemDAOImp();
//
//		List<OrderItem> li = oi.getOrderItemsByOrder(v);
//
//		for (OrderItem o : li) {
//		    System.out.println(o);
//		}
		
//		String email=sc.nextLine();
//		UserDAOImp im=new UserDAOImp();
//		User user=im.getUserEmail(email);
//		System.out.print(user);
		
	}

}
