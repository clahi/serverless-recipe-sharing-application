import json
import boto3
from typing import List, Dict
from decimal import Decimal
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('recipes')

class Ingredient(Dict):
    def __init__(self, id: int, description: str):
        super().__init__(id=id, description=description)

class Step(Dict):
    def __init__(self, id: int, description: str):
        super().__init__(id=id, description=description)

class Recipe(Dict):
    def __init__(self, id: str, title: str, ingredients: List[Ingredient], steps: List[Step], likes: int):
        super().__init__(id=id, title=title, ingredients=ingredients, steps=steps, likes=likes)


def default_serializer(obj):
    if isinstance(obj, set):
        return list(obj)
    if isinstance(obj, Decimal):
        return float(obj)
    return str(obj)

def lambda_handler(event, context):
    try:
        response = table.scan()
        recipes = response['Items']

        while 'LastEvaluateKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            recipes.extend(response['Items'])
        
        print('----------my test -----response---------')
        print(response)

        print('----------my test -----recipes---------')
        print(recipes)

        recipes_list = []
        for recipe in recipes:
            ingredients = [Ingredient(ing['id'], ing['description']) for ing in recipe['ingredients']]
            
            steps = [Step(step['id'], step['description']) for step in recipe['steps']]
            recipes_list.append(Recipe(recipe['id'], recipe['title'], ingredients, steps, recipe['likes']))

        print("-------------")
        print(recipes_list)

        for i in recipes_list:
            print(type(i))
        # return recipes_list
        return {
            "statusCode": 200,
            "headers": { "Content-Type": "application/json" },
            "body": json.dumps(recipes_list, default=default_serializer)
        }
    except Exception as e:
        return {
        "statusCode": 500,
        "headers": { "Content-Type": "application/json" },
        "body": json.dumps({"message": f"Error retrieving recipes: {e}"})
        }