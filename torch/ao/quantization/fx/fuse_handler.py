from .fusion_patterns import DefaultFuseHandler

# TODO: move DefaultFuseHandler
def get_fuse_handler_cls():
    return DefaultFuseHandler

__all__ = [
    "get_fuse_handler_cls",
]
