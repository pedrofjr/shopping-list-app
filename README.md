# 🛒 Shopping List Manager

Aplicativo Flutter para gerenciar lista de compras integrado com API REST. Gerencie itens com CRUD completo, ajuste de quantidades e confirmação inteligente de exclusão.

## ✨ Funcionalidades

- Adicionar/Editar/Remover itens da lista
- Ajuste de quantidades com botões +/- e validação
- Swipe para excluir com confirmação
- Persistência de dados via API REST
- Interface intuitiva e responsiva

## 🛠 Tecnologias

**Frontend:**
- Flutter 3.0+
- HTTP Client
- Dismissible Widget

**Backend:**
- Java 17
- Spring Boot 3.2+
- Spring Data JPA
- Banco de dados H2 (dev)

## ⚙️ Instalação

```bash
git clone https://github.com/pedrofjr/shopping-list-app.git
cd shopping-list-app
flutter pub get
flutter run
```

## 📡 Endpoints da API

| Método | Endpoint       | Descrição                     |
|--------|----------------|-------------------------------|
| GET    | /items         | Lista todos os itens          |
| POST   | /items         | Cria novo item                |
| PUT    | /items/{id}    | Atualiza item existente       |
| DELETE | /items/{id}    | Remove item                   |
| PUT    | /items/reorder | Atualiza ordem dos itens      |

## 🤝 Contribuição
Contribuições são bem-vindas! Siga esses passos:
1. Faça o fork do projeto
2. Crie sua branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença
MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes
