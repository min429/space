package com.project.repository;

import com.project.domain.Users;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class UsersRepository {


    private final EntityManager em;


    public void save(Users member){
        em.persist(member);
    }

    public Users findOne(Long id) {
        return em.find(Users.class,id);
    }

    public List<Users> findAll(){

        List<Users> result = em.createQuery("select m from  Users  m", Users.class)
                .getResultList();

        return result;
    }

    public List<Users> findByName(String name) {
        return em.createQuery("select m from Users m where m.name = :name", Users.class)
                .setParameter("name", name)
                .getResultList();
    }

}
