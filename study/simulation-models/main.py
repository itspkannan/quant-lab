import asyncio
import uvloop
from simulation_models.app import startup

if __name__ == "__main__":
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())
    startup()
