Hello there,

This is an ongoing Skill System I'm working on.  
It contains a Skill Tree and a Mastery system for leveling.

The system uses an Event-Driven Architecture Design with isolated and independent microservices.  
There's also a Queue System, since parallel signals can cause weird sync issues — using a queue was the more advanced and stable way to solve that (and more).

On the client side, we've got a nice reactive UI.  
Most UIs are handled through **Fusion** and a custom **Statemanager**, which makes everything feel dynamic and snappy.

I’ve added more README files inside the `src` folder, so you can see exactly what's happening in the right context.  
I hope you don’t get lost — and I hope it’s not too bad 😅
