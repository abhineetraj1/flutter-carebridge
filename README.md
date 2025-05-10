# Carebridge

Carebridge is a mobile application designed to streamline the connection between caretakers and elderly patients, facilitating the efficient management and booking of caregiving services. The platform allows caretakers to sign up, indicating their availability, while patients can search and book caretakers based on proximity. The app incorporates an OTP verification process to ensure secure session initiation. Additionally, a caretaker availability algorithm ensures that only free caretakers are assigned, optimizing both patient care and system performance. Carebridge aims to improve the caregiving experience for both patients and caretakers through enhanced efficiency, security, and adaptability.

## Workflow

![image](https://github.com/abhineetraj1/flutter-carebridge/raw/main/image/workflow.png)

Carebridge is a mobile application designed to connect caretakers and elderly patients, allowing both parties to manage and book caregiving services efficiently. Caretakers can sign up on the platform, enabling them to receive bookings for patient care when they are available and not currently occupied with other patients. The application allows patients to search for available caretakers by clicking the "Book a Caretaker" button. After a brief waiting period, a caretaker is assigned, with both the caretaker and patient able to view the distance between each other. Once the OTP is verified, the caregiving session begins. Additionally, the caretaker availability algorithm ensures that only those who are free to take bookings and not engaged with another patient are considered for assignment. 

## Setup

### 1. Clone the Project

First, clone the project repository from GitHub to your local machine

### 2. Set Up Flutter and 

Before working on the project, ensure that Flutter and dependencies are installed on your system.

```
flutter pub get
```

#### Install Flutter

Follow the official instructions to install Flutter on your system:

- [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

Once Flutter is installed, ensure it's set up correctly by running:

```
flutter doctor
```

This command will check your installation and report any missing dependencies. Make sure to address any issues before proceeding.

#### Install 

 comes bundled with Flutter, so once Flutter is installed,  will be available. You can verify the  installation with:

```
 --version
```

If  is not installed, you can follow the [ installation instructions](https://.dev/get-).

### 3. Set Up MongoDB and Create the Collection

To set up MongoDB, follow these steps:

#### a. Install MongoDB

If MongoDB is not installed on your local machine, follow the instructions for your operating system:

- [MongoDB Installation Guide](https://docs.mongodb.com/manual/installation/)

#### b. Create the Database and Collections

1. Start the MongoDB service:
   ```
   mongod
   ```

2. Open another terminal window and access the MongoDB shell:
   ```
   mongo
   ```

3. Create a new database named "carebridge" and add two collections named "bookings" and "accounts":

   ```
   use carebridge
   db.createCollection('bookings')
   db.createCollection('accounts')
   ```

4. Insert some sample data into the collections (optional):

   ```
   db.bookings.insert({ patient_id: 1, caretaker_id: 1, booking_time: "2025-04-10T10:00:00" })
   db.accounts.insert({ username: "john_doe", password: "securepassword123", role: "caretaker" })
   ```

#### c. MongoDB Atlas (Optional)

If you prefer to use MongoDB Atlas (a cloud-based solution), sign up and follow the [MongoDB Atlas setup instructions](https://www.mongodb.com/cloud/atlas) to create a database and obtain a connection string.


### 4. Update MongoDB Connection URL in the `main.` File

Once you have your MongoDB connection URL (either local or from MongoDB Atlas), you will need to update the `main.` file in your Flutter project.

1. Open the `main.` file, typically located in the `lib/` folder of your project.
   
2. Locate the section where the database URL is defined (it could look something like this):

   ```
   const String mongoDbUrl = "mongodb://localhost:27017";
   ```

3. Replace the placeholder with your actual MongoDB URL:

   - Local MongoDB Connection (Example):
     ```
     const String mongoDbUrl = "mongodb://127.0.0.1:27017";
     ```

   - MongoDB Atlas Connection (Example):
     ```
     const String mongoDbUrl = "mongodb+srv://username:password@cluster0.mongodb.net/carebridge?retryWrites=true&w=majority";
     ```

   Ensure you replace `username`, `password`, and `cluster0.mongodb.net` with your actual MongoDB Atlas credentials and connection details.


### 5. Run the Flutter Application

Once everything is set up, you can run the Flutter application to ensure that the changes are working correctly.

In the root directory of your Flutter project, run the following command:

```
flutter run
```

This will build and launch the app, ensuring it can connect to the MongoDB database using the URL you provided.

### 6. Verify the Database Connection

Ensure the Flutter application is correctly interacting with the MongoDB collections (`bookings` and `accounts`). You can check the logs for any errors related to database connection issues.

If you're using MongoDB Atlas, ensure that your cluster is properly configured to accept connections from your IP address, and the credentials are correct.



## Languages and Tools:
<p align="left"> <a href="https://dart.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/> </a> <a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> <a href="https://www.mongodb.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original-wordmark.svg" alt="mongodb" width="40" height="40"/> </a> </p>

## Developer
*   [Abhineet Raj](https://github.com/abhineetraj1)