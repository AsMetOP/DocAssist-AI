<div align="center">

<img src="https://img.shields.io/badge/DoccyAI-Multimodal%20Medical%20Assistant-1a9c6e?style=for-the-badge&logo=heart&logoColor=white" alt="DoccyAI Banner"/>

# 🩺 DoccyAI

### Multimodal Medical Assistant for Preliminary Health Assessments

*Because getting a first opinion shouldn't require a waiting room.*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?style=flat-square&logo=scikit-learn&logoColor=white)](https://scikit-learn.org)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com)
[![HuggingFace](https://img.shields.io/badge/🤗%20HuggingFace-Spaces-FFD21E?style=flat-square)](https://huggingface.co/spaces)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

</div>

---

## 📖 Overview

**DoccyAI** is a cross-platform mobile application that acts as a preliminary health assessment companion. Users describe their symptoms through a conversational interface, and DoccyAI uses a trained ML model to suggest possible conditions — all without a single phone call to a clinic.

> ⚠️ **Disclaimer:** DoccyAI is designed for **preliminary, informational purposes only**. It is **not a substitute** for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider.

The project bridges mobile-first UX (Flutter) with a Python ML backend (FastAPI + scikit-learn), packaged in Docker and deployed on HuggingFace Spaces.

---

## ✨ Features

- 🔍 **Symptom-based Disease Prediction** — Logistic Regression model trained on curated symptom–disease datasets
- 📱 **Cross-platform Mobile App** — Flutter frontend supporting Android & iOS from a single codebase
- ⚡ **REST API Backend** — FastAPI backend with clean, auto-documented endpoints (`/docs`)
- 🐳 **Fully Containerised** — Docker setup for consistent local and production environments
- 🌐 **Cloud Deployed** — Live inference API hosted on HuggingFace Spaces
- 🔄 **CORS-Configured** — Secure cross-origin handling between the Flutter app and API

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (Dart)                   │
│         Cross-platform Mobile UI (Android / iOS)        │
└────────────────────────┬────────────────────────────────┘
                         │ HTTP REST (JSON)
                         ▼
┌─────────────────────────────────────────────────────────┐
│              FastAPI Backend (Python)                   │
│     /predict  →  Logistic Regression (.pkl model)       │
│     Auto-docs at /docs  |  CORS enabled                 │
└────────────────────────┬────────────────────────────────┘
                         │
            ┌────────────┴────────────┐
            ▼                         ▼
     🐳 Docker Container     🤗 HuggingFace Spaces
     (Local Dev / Prod)       (Live Deployment)
```

---

## 🧠 ML Model

| Property        | Details                              |
|-----------------|--------------------------------------|
| Algorithm       | Logistic Regression (scikit-learn)   |
| Input           | Binary symptom vector                |
| Output          | Predicted disease label + confidence |
| Serialisation   | `.pkl` (Git LFS tracked)             |
| Library Version | `scikit-learn == 1.5.2` (pinned)     |

> **Why Logistic Regression?** It's interpretable, fast at inference, and performs surprisingly well on structured symptom-disease datasets — a conscious choice of a model that a doctor could actually reason about, rather than a black-box neural net.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.x
- Python 3.9+
- Docker (optional, for containerised setup)
- Git LFS (for `.pkl` model files)

```bash
git lfs install
git clone https://github.com/AsMetOP/DoccyAI.git
cd DoccyAI
```

---

### 🐍 Backend Setup (FastAPI)

```bash
cd backend

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start the development server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

API will be live at `http://localhost:8000`
Interactive docs at `http://localhost:8000/docs`

---

### 🐳 Docker Setup

```bash
cd backend
docker build -t doccyai-backend .
docker run -p 8000:8000 doccyai-backend
```

---

### 📱 Flutter App Setup

```bash
cd frontend

# Fetch dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

> Update the API base URL in the app config to point to your local backend or the live HuggingFace endpoint.

---

## 📡 API Reference

### `POST /predict`

Accepts a list of symptoms and returns the predicted condition.

**Request Body:**
```json
{
  "symptoms": ["headache", "fever", "fatigue"]
}
```

**Response:**
```json
{
  "prediction": "Influenza",
  "confidence": 0.87
}
```

---

## 📂 Project Structure

```
DoccyAI/
├── backend/
│   ├── main.py               # FastAPI app & CORS config
│   ├── model/
│   │   └── model.pkl         # Trained LR model (Git LFS)
│   ├── requirements.txt      # Pinned dependencies
│   └── Dockerfile
│
├── frontend/
│   ├── lib/
│   │   ├── main.dart         # App entry point
│   │   ├── screens/          # UI screens
│   │   └── services/         # API service layer
│   └── pubspec.yaml
│
└── README.md
```

---

## 👥 Team

| Contributor | Role |
|---|---|
| [Asmet Sahoo](https://github.com/AsMetOP) | ML Engineer — Model, FastAPI Backend, Docker, HuggingFace Deployment |
| [Astha Upadhyay](https://github.com/Astha070405) | Database |
| [Krish Agrawal](https://github.com/Krishagrawal04) | Testing |
| [Sneha Das](https://github.com/Sneha009-beep) | Frontend Development |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile Frontend | Flutter / Dart |
| ML Backend | FastAPI + scikit-learn |
| ML Model | Logistic Regression |
| Containerisation | Docker |
| Cloud Deployment | HuggingFace Spaces |
| Version Control | Git + Git LFS |

---

## 🔮 Roadmap

- [ ] Add multimodal input (image + symptom text)
- [ ] Expand disease coverage with a richer dataset
- [ ] Add explainability layer (SHAP values per prediction)
- [ ] Integrate appointment booking / doctor referral
- [ ] Offline inference with on-device model (TFLite / ONNX)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<div align="center">
  <sub>Built with ❤️ by the DoccyAI team · KIIT University, Bhubaneswar</sub>
</div>
