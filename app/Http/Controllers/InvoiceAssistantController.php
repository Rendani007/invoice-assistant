<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Http;
use Log;


class InvoiceAssistantController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        return Inertia::render('InvoiceAssistant');
    }

    //generating the invoice
    Public function generate (Request $request)
    {
        $validated = $request->validate([
            'client' => 'required|string',
            'invoice_date' => 'required|date',
            'items' => 'required|string',
            'due_date' => 'required|date',
        ]);

        $prompt = "Generate an invoice summary and follow-up email for the following:
            Client: {$validated['client']}
            Invoice Date: {$validated['invoice_date']}
            Items: {$validated['items']}
            Due Date: {$validated['due_date']}";

            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . config('services.openrouter.key'),
                'HTTP-Referer' => 'http://localhost:8000/invoice-assistant', // required by OpenRouter!
                'X-Title' => 'Invoice Assistant',
                ])->post('https://openrouter.ai/api/v1/chat/completions', [
                    'model' => 'meta-llama/llama-3-70b-instruct',
                    'messages' => [
                        ['role' => 'system', 'content' =>  'You are an invoice assistant that outputs clean summaries and polite follow-up emails.'],
                        ['role' => 'user', 'content' =>  $prompt]
                    ],
                    'temperature' => 0.6,
                ]);


                // // Log full response for debugging
                // Log::info('OpenAI response:', $response->json());

                // // Check if response contains choices
                // if (isset($response['choices'][0]['message']['content'])) {
                //     return response()->json([
                //         'output' => $response['choices'][0]['message']['content'],
                //     ]);
                // }

                return response()->json([
                    'output' => $response['choices'][0]['message']['content'] ?? 'No response from model',

            ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
