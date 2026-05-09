-- CreateEnum
CREATE TYPE "AuthProvider" AS ENUM ('LOCAL', 'FACEBOOK');

-- CreateTable
CREATE TABLE "users" (
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "photoUrl" TEXT,
    "phoneNumber" TEXT NOT NULL,
    "jobTitle" TEXT NOT NULL,
    "authProvider" "AuthProvider" NOT NULL DEFAULT 'LOCAL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("email")
);

-- CreateTable
CREATE TABLE "devices" (
    "id" TEXT NOT NULL,
    "fcmToken" TEXT NOT NULL,
    "userEmail" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "senderEmail" TEXT NOT NULL,
    "recipientEmail" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "push_deliveries" (
    "id" TEXT NOT NULL,
    "messageId" TEXT NOT NULL,
    "deviceId" TEXT NOT NULL,
    "fcmToken" TEXT NOT NULL,
    "success" BOOLEAN NOT NULL,
    "fcmResponse" JSONB NOT NULL,
    "errorCode" TEXT,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "push_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "devices_fcmToken_key" ON "devices"("fcmToken");

-- CreateIndex
CREATE INDEX "devices_userEmail_idx" ON "devices"("userEmail");

-- CreateIndex
CREATE INDEX "messages_recipientEmail_createdAt_idx" ON "messages"("recipientEmail", "createdAt");

-- CreateIndex
CREATE INDEX "messages_senderEmail_createdAt_idx" ON "messages"("senderEmail", "createdAt");

-- CreateIndex
CREATE INDEX "push_deliveries_messageId_idx" ON "push_deliveries"("messageId");

-- CreateIndex
CREATE INDEX "push_deliveries_deviceId_idx" ON "push_deliveries"("deviceId");

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_userEmail_fkey" FOREIGN KEY ("userEmail") REFERENCES "users"("email") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_senderEmail_fkey" FOREIGN KEY ("senderEmail") REFERENCES "users"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_recipientEmail_fkey" FOREIGN KEY ("recipientEmail") REFERENCES "users"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_deliveries" ADD CONSTRAINT "push_deliveries_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_deliveries" ADD CONSTRAINT "push_deliveries_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE CASCADE ON UPDATE CASCADE;
