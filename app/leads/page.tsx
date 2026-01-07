import type { Lead, LeadStatus } from "@prisma/client";

import { prisma } from "@/lib/prisma";

const STATUS_OPTIONS: LeadStatus[] = [
  "NOT_CONTACTED",
  "CONTACTED",
  "INTERESTED",
  "SAMPLE_SENT",
  "SELLING",
  "NOT_A_FIT",
];

async function getLeads(): Promise<Lead[]> {
  return prisma.lead.findMany({
    orderBy: { createdAt: "desc" },
  });
}

export default async function LeadsPage() {
  const leads = await getLeads();

  return (
    <div className="min-h-screen bg-white px-6 py-10 text-slate-900">
      <div className="mx-auto flex w-full max-w-5xl items-center justify-between">
        <div>
          <h1 className="text-3xl font-semibold">Leads</h1>
          <p className="mt-1 text-sm text-slate-500">
            Track new leads and follow up fast.
          </p>
        </div>
        <button
          className="rounded-md bg-slate-900 px-4 py-2 text-sm font-semibold text-white"
          type="button"
        >
          Add Lead
        </button>
      </div>

      <div className="mx-auto mt-8 w-full max-w-5xl overflow-hidden rounded-lg border border-slate-200">
        <table className="w-full text-left text-sm">
          <thead className="bg-slate-50 text-xs uppercase tracking-wide text-slate-500">
            <tr>
              <th className="px-4 py-3">Name</th>
              <th className="px-4 py-3">Category</th>
              <th className="px-4 py-3">City</th>
              <th className="px-4 py-3">Status</th>
            </tr>
          </thead>
          <tbody>
            {leads.length === 0 ? (
              <tr>
                <td className="px-4 py-6 text-slate-500" colSpan={4}>
                  No leads yet. Add your first one.
                </td>
              </tr>
            ) : (
              leads.map((lead) => (
                <tr
                  key={lead.id}
                  className="border-t border-slate-100 text-slate-700"
                >
                  <td className="px-4 py-4 font-medium text-slate-900">
                    {lead.name}
                  </td>
                  <td className="px-4 py-4">
                    {lead.category ?? "—"}
                  </td>
                  <td className="px-4 py-4">{lead.city}</td>
                  <td className="px-4 py-4">
                    <select
                      className="rounded-md border border-slate-200 bg-white px-2 py-1 text-sm"
                      defaultValue={lead.status}
                    >
                      {STATUS_OPTIONS.map((status) => (
                        <option key={status} value={status}>
                          {status.replace(/_/g, " ")}
                        </option>
                      ))}
                    </select>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
