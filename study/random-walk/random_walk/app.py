from functools import partial

from sanic import Blueprint, Sanic
from sanic.worker.loader import AppLoader
from sanic_ext import Extend

from random_walk.controllers import HealthCheckController
from random_walk.controllers.randomwalk_controller import RandomwalkController


def register_routes(app: Sanic):
    health_controller = HealthCheckController()
    health_check_bp = Blueprint("healthcheck")
    health_check_bp.add_route(health_controller.get, "/health", methods=["GET"])

    metrics_controller = RandomwalkController()
    metrics_bp = Blueprint("metrics", url_prefix="/api/v1")
    metrics_bp.add_route(metrics_controller.metrics, "/data/metrics", methods=["GET"])
    metrics_bp.add_route(metrics_controller.prices, "/data/price", methods=["GET"])
    app.blueprint(health_check_bp)
    app.blueprint(metrics_bp)


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
