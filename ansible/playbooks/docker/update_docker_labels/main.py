import logging

import docker
import typer

from ansible.parsing.dataloader import DataLoader
from ansible.inventory.manager import InventoryManager


def update_docker_node_labels(inventory_file: str):
    inventory = InventoryManager(loader=DataLoader(), sources=[inventory_file])

    for host in inventory.get_hosts():
        logging.info(f"Updating docker node labels on {host=}")
        node = docker_client.nodes.get(host.get_name())
        node_spec = node.attrs["Spec"]
        node_labels = {
            tag.strip().lower(): "true" for tag in host.vars["tags"].split(",")
        }
        node_spec["Labels"] = node_labels

        try:
            node.update(node_spec)
        except docker.errors.APIError as e:
            logging.error(f"Failed to update docker node labels: {e}")
            raise e

    if inventory.get_hosts():
        logging.info("Updating docker node labels completed")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    docker_client = docker.from_env()

    typer.run(update_docker_node_labels)
