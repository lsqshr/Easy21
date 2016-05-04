# Easy21
Implementation for the Easy 21 Task for the RL course given by David Silver at (http://www0.cs.ucl.ac.uk/staff/D.Silver/web/Teaching_files/Easy21-Johannes.pdf)

```manual.m```: Run game simulator by using Easy21Env class to play the game manually in console

```MC.m```: Train the RL agent with first-time Monte Carlo algorithm with a varying eps.
Example Usage:
```
>>> p.plot = true
>>> p.test = false
>>> p.showevery = 1e4
>>> p.snapshotevery = 5e5
>>> MC(p)
```

```Easy21Env```: The Easy 21 game simulator
