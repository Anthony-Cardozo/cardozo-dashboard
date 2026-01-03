-- CreateEnum
CREATE TYPE "LeadStatus" AS ENUM ('NOT_CONTACTED', 'CONTACTED', 'INTERESTED', 'SAMPLE_SENT', 'SELLING', 'NOT_A_FIT');

-- CreateEnum
CREATE TYPE "ContactType" AS ENUM ('EMAIL', 'PHONE', 'INSTAGRAM', 'WEBSITE');

-- CreateEnum
CREATE TYPE "OutreachChannel" AS ENUM ('EMAIL', 'INSTAGRAM', 'SMS', 'IN_PERSON');

-- CreateEnum
CREATE TYPE "OutreachOutcome" AS ENUM ('NO_REPLY', 'REPLIED', 'INTERESTED', 'NOT_INTERESTED');

-- CreateEnum
CREATE TYPE "TaskStatus" AS ENUM ('TODO', 'DOING', 'DONE');

-- CreateTable
CREATE TABLE "Lead" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "city" TEXT NOT NULL DEFAULT 'Dallas',
    "category" TEXT,
    "status" "LeadStatus" NOT NULL DEFAULT 'NOT_CONTACTED',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Lead_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contact" (
    "id" TEXT NOT NULL,
    "leadId" TEXT NOT NULL,
    "type" "ContactType" NOT NULL,
    "value" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Contact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OutreachAttempt" (
    "id" TEXT NOT NULL,
    "leadId" TEXT NOT NULL,
    "channel" "OutreachChannel" NOT NULL,
    "subject" TEXT,
    "message" TEXT NOT NULL,
    "outcome" "OutreachOutcome" NOT NULL DEFAULT 'NO_REPLY',
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OutreachAttempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Task" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "leadId" TEXT,
    "assignedTo" TEXT,
    "status" "TaskStatus" NOT NULL DEFAULT 'TODO',
    "dueDate" TIMESTAMP(3),
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Task_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Lead_status_idx" ON "Lead"("status");

-- CreateIndex
CREATE INDEX "Lead_city_idx" ON "Lead"("city");

-- CreateIndex
CREATE INDEX "Contact_leadId_idx" ON "Contact"("leadId");

-- CreateIndex
CREATE UNIQUE INDEX "Contact_type_value_key" ON "Contact"("type", "value");

-- CreateIndex
CREATE INDEX "OutreachAttempt_leadId_idx" ON "OutreachAttempt"("leadId");

-- CreateIndex
CREATE INDEX "OutreachAttempt_sentAt_idx" ON "OutreachAttempt"("sentAt");

-- CreateIndex
CREATE INDEX "Task_status_idx" ON "Task"("status");

-- CreateIndex
CREATE INDEX "Task_assignedTo_idx" ON "Task"("assignedTo");

-- CreateIndex
CREATE INDEX "Task_dueDate_idx" ON "Task"("dueDate");

-- AddForeignKey
ALTER TABLE "Contact" ADD CONSTRAINT "Contact_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "Lead"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OutreachAttempt" ADD CONSTRAINT "OutreachAttempt_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "Lead"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Task" ADD CONSTRAINT "Task_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "Lead"("id") ON DELETE SET NULL ON UPDATE CASCADE;
