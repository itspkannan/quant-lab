from functools import partial

from sanic import Blueprint, Sanic
from sanic.worker.loader import AppLoader
from sanic_ext import Extend

from simulation_models.controllers import HealthCheckController
from simulation_models.controllers.simulation import SimulationController


def register_routes(app: Sanic):
    health_controller = HealthCheckController()
    health_check_bp = Blueprint("healthcheck")
    health_check_bp.add_route(health_controller.get, "/health", methods=["GET"])

    simulation_controller = SimulationController()
    simulation_bp = Blueprint("metrics", url_prefix="/api/v1")
    simulation_bp.add_route(simulation_controller.metrics, "/data/metrics", methods=["GET"])
    simulation_bp.add_route(simulation_controller.prices, "/data/price", methods=["GET"])
    simulation_bp.add_route(simulation_controller.montecarlo, "/data/montecarlo", methods=["GET"])
    app.blueprint(health_check_bp)
    app.blueprint(simulation_bp)


def __create_app(app_name: str, **kwargs):
    app = Sanic(app_name)
    Extend(app)
    register_routes(app)
    return app


def startup(app_name: str = 'RandomWalkAPI'):
    loader = AppLoader(factory=partial(__create_app, app_name))
    app = loader.load()
    app.prepare(
        host='0.0.0.0',
        port=8000,
        workers=1,
        dev=False,
        access_log=True
    )

    Sanic.serve(primary=app, app_loader=loader)
