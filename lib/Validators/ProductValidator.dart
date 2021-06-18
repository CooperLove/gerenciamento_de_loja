class ProductValidator {
  String imagesValidator(List images) {
    return images.isEmpty ? "Insira imagens do produto!" : null;
  }

  String titleValidator(String title) {
    return title.isEmpty ? "Insira um titulo!" : null;
  }

  String descriptionValidator(String desc) {
    return desc.isEmpty ? "Insira a descrição do produto!" : null;
  }

  String priceValidator(String priceText) {
    double price = double.tryParse(priceText);

    if (price == null)
      return "Insira um valor válido!";
    else {
      if (!priceText.contains(".") || priceText.split(".")[1].length != 2)
        return "Utilize duas casas decimais.";
    }

    return null;
  }
}
