import { NextResponse } from "next/server";

import { prisma } from "@/lib/prisma";

export async function GET() {
  const leads = await prisma.lead.findMany({
    orderBy: { createdAt: "desc" },
  });

  return NextResponse.json(leads);
}

export async function POST(request: Request) {
  const body = (await request.json()) as {
    name?: string;
    category?: string | null;
    city?: string | null;
  };

  if (!body.name) {
    return NextResponse.json({ error: "Name is required." }, { status: 400 });
  }

  const lead = await prisma.lead.create({
    data: {
      name: body.name,
      category: body.category ?? undefined,
      city: body.city ?? "Dallas",
    },
  });

  return NextResponse.json(lead, { status: 201 });
}
