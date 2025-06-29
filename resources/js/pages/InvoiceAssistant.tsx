import { useState } from 'react';
import axios from 'axios';

// Define the shape of the form state
interface FormState {
  client: string;
  invoice_date: string;
  items: string;
  due_date: string;
}

const InvoiceAssistant: React.FC = () => {
  const [form, setForm] = useState<FormState>({
    client: '',
    invoice_date: '',
    items: '',
    due_date: '',
  });
  const [result, setResult] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(false);

  // Handle input and textarea changes
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  // Handle form submission
  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    try {
      const res = await axios.post<{ output: string }>('/generate-invoice-summary', form);
      setResult(res.data.output);
    } catch (error) {
      console.error('Error submitting form:', error);
      // Optionally display error to user
      setResult('Failed to generate summary. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-xl mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">AI Invoice Assistant</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          name="client"
          value={form.client}
          onChange={handleChange}
          placeholder="Client Name"
          className="w-full p-2 border rounded"
          required
        />
        <input
          name="invoice_date"
          type="date"
          value={form.invoice_date}
          onChange={handleChange}
          className="w-full p-2 border rounded"
          required
        />
        <textarea
          name="items"
          value={form.items}
          onChange={handleChange}
          placeholder="Item details (e.g., Web design R10,000)"
          rows={3}
          className="w-full p-2 border rounded"
          required
        />
        <input
          name="due_date"
          type="date"
          value={form.due_date}
          onChange={handleChange}
          className="w-full p-2 border rounded"
          required
        />
        <button
          type="submit"
          className="bg-blue-600 text-white px-4 py-2 rounded"
          disabled={loading}
        >
          {loading ? 'Generating...' : 'Generate Summary'}
        </button>
      </form>
      {result && (
        <div className="mt-6 bg-green-600 p-4 rounded shadow">
          <h2 className="font-semibold mb-2">Generated Output:</h2>
          <pre className="whitespace-pre-wrap">{result}</pre>
        </div>
      )}
    </div>
  );
};

export default InvoiceAssistant;
