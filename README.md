# Mini Tracker (Sehir360 Prototype)

Bu proje, görev (task) ve alışkanlık (habit) takibi yapılabilen, Clean Architecture prensiplerine uygun olarak geliştirilmiş bir Flutter uygulamasıdır.

## Projenin Nasıl Çalıştırılacağı

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyebilirsiniz:

1.  **Gereksinimler:**
    *   Flutter SDK (Sürüm 3.10.4 veya üzeri)
    *   Dart SDK

2.  **Bağımlılıkların Yüklenmesi:**
    Proje dizininde terminali açın ve gerekli paketleri indirmek için şu komutu çalıştırın:
    ```bash
    flutter pub get
    ```

3.  **Code Generation (Gerekliyse):**
    Proje Hive veritabanı kullandığı için adapter'ların oluşturulması gerekebilir. Bunun için:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Uygulamanın Başlatılması:**
    Uygulamayı bir emülatör veya fiziksel cihazda çalıştırmak için:
    ```bash
    flutter run
    ```

## Kısa Mimari Açıklama

Proje, sürdürülebilirlik, test edilebilirlik ve sorumlulukların ayrılması ilkelerine dayanan **Clean Architecture** yapısını benimsemiştir. Kod tabanı üç ana katmana ayrılmıştır:

*   **Presentation (Sunum) Katmanı (`lib/presentation`):** Kullanıcı arayüzü (UI), widget'lar ve State Management mantığını içerir. Domain katmanıyla etkileşime girerek verileri kullanıcıya sunar.
*   **Domain (İş) Katmanı (`lib/domain`):** Uygulamanın merkezi iş mantığını, Entities (Varlıklar) ve Repository arayüzlerini barındırır. Hiçbir dış bağımlılığı yoktur (Flutter, veritabanı vb. bağımsızdır).
*   **Data (Veri) Katmanı (`lib/data`):** Verilerin nereden geldiğini (Local veya Remote) yönetir. Domain katmanındaki repository arayüzlerini implemente eder.
    *   **Local Datasource:** Hive kullanarak verileri yerel cihazda saklar (Offline-first).
    *   **Remote Datasource:** Mock bir backend servisi simüle eder.

Bu yapı sayesinde uygulama, veri kaynağı değişikliklerinden veya UI güncellemelerinden etkilenmeden geliştirilebilir.

## Seçilen State Management ve Gerekçesi

Bu projede State Management çözümü olarak **Provider** kullanılmıştır.

**Seçim Gerekçesi:**
1.  **Flutter Ekibinin Önerisi:** Flutter dokümantasyonunda resmi olarak önerilen, güvenilir ve yaygın bir çözümdür.
2.  **Sadelik ve Etkinlik:** Karmaşık boilerplate kodlarına ihtiyaç duymadan, `ChangeNotifier` yapısı ile durum yönetimini (State Management) ve UI güncellemelerini verimli bir şekilde gerçekleştirir.
3.  **Dependency Injection (Bağımlılık Enjeksiyonu):** Provider, sadece state yönetimini değil, aynı zamanda servislerin ve controller'ların widget ağacı üzerinde etkin bir şekilde dağıtılmasını (Dependency Injection) da sağlar.
4.  **Test Edilebilirlik:** Controller sınıflarının UI'dan bağımsız olarak test edilmesini kolaylaştırır.
