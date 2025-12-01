import pytest
from rest_framework.test import APIClient
from logistic.models import Product


@pytest.fixture
def client():
    """Фикстура для клиента API"""
    return APIClient()


@pytest.mark.django_db
def test_add_product(client):
    """Тест успешного создания товара"""
    products_count = Product.objects.count()
    data = {
        'title': 'Баклажан',
        'description': 'Самый свежий баклажан'
    }
    response = client.post('/api/v1/products/', data)

    # Проверим, что вернулся статус 201
    assert response.status_code == 201, (
        f'Cервер вернул статус {response.status_code} вместо 201'
    )
    # Проверим, что в результате запроса в БД была создана 1 запись
    assert Product.objects.count() == products_count+1, (
        f'Число товаров до {products_count}, после - {Product.objects.count()}'
    )
