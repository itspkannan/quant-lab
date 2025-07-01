import asyncio
import uvloop
from random_walk.app import startup

if __name__ == "__main__":
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())
    startup()
