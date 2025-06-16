import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const contentType = request.headers.get('content-type') || '';
    let usuario_id: string | undefined;
    let messagesRaw: Array<any> = [];
    let stream = true;
    let model = 'Modelfile_Adan_CEO';

    if (contentType.includes('application/json')) {
      try {
        const json = await request.json();
        usuario_id = json.usuario_id;
        messagesRaw = json.messages;
        stream = json.stream === undefined ? true : Boolean(json.stream);
        model = json.model || model;
      } catch (jsonError) {
        console.error('Error parsing JSON body:', jsonError);
        return NextResponse.json({ error: 'Invalid JSON body' }, { status: 400 });
      }
    } else if (contentType.includes('multipart/form-data')) {
      const formData = await request.formData();
      usuario_id = formData.get('usuario_id') as string;
      const message = formData.get('message') as string;
      const chatHistory = JSON.parse(formData.get('chat_history') as string || '[]');
      model = (formData.get('model') as string) || model;
      stream = true;

      messagesRaw = [
        ...chatHistory,
        { role: 'user', content: message },
      ];
    } else {
      return NextResponse.json({ error: 'Unsupported Content-Type' }, { status: 415 });
    }

    if (!usuario_id || typeof usuario_id !== 'string' || usuario_id.trim() === '') {
      if (messagesRaw.length > 0 && typeof messagesRaw[0].user_id === 'string') {
        usuario_id = messagesRaw[0].user_id;
      } else {
        usuario_id = 'unknown_user';
      }
    }

    const messages = messagesRaw.map((msg) => ({
      role: msg.role,
      content: msg.content,
    }));

    console.log('📨 Usuario ID:', usuario_id);
    console.log('📨 Mensajes recibidos:', messages);
    console.log('🤖 Modelo:', model);
    console.log('🔄 Stream:', stream);

    const mainPayload = {
      model,
      messages,
      stream,
    };

    console.log('📤 Payload enviado a instancia Deepseek:', JSON.stringify(mainPayload));

    const DEEPSEEK_BASE_URL = 'http://localhost:8000/v1/completions';
    const headers = { 'Content-Type': 'application/json' };

    const mainResponse = await fetch(DEEPSEEK_BASE_URL, {
      method: 'POST',
      headers,
      body: JSON.stringify(mainPayload),
    });

    if (!mainResponse.ok) {
      const errorText = await mainResponse.text();
      console.error('❌ Error en Deepseek:', errorText);
      throw new Error(`Error de Deepseek: ${mainResponse.status} - ${errorText}`);
    }

    const streamResponse = new ReadableStream({
      async start(controller) {
        const decoder = new TextDecoder();
        const reader = mainResponse.body?.getReader();

        if (!reader) {
          controller.error(new Error('No reader available on response body'));
          return;
        }

        try {
          let fullMessage = '';
          let rawResponse = '';

          while (true) {
            const { done, value } = await reader.read();

            if (done) {
              console.log('📥 Stream cerrado, mensaje completo:', fullMessage);

              if (!fullMessage.trim() && rawResponse.trim()) {
                fullMessage = rawResponse.trim();
                controller.enqueue(`data: ${JSON.stringify({ content: fullMessage })}\n\n`);
              } else if (!fullMessage.trim()) {
                fullMessage = "Lo siento, hubo un problema al generar la respuesta. Por favor, intenta de nuevo.";
                controller.enqueue(`data: ${JSON.stringify({ content: fullMessage })}\n\n`);
              }
              break;
            }

            const chunk = decoder.decode(value, { stream: true });
            console.log('📤 Chunk recibido de Deepseek:', chunk);
            rawResponse += chunk;

            if (chunk.includes('⏳ Procesando...')) {
              continue;
            }

            let extractedContent = '';

            try {
              const jsonResponse = JSON.parse(chunk);
              if (jsonResponse.response) {
                extractedContent = jsonResponse.response;
              } else if (jsonResponse.content) {
                extractedContent = jsonResponse.content;
              } else if (jsonResponse.choices && jsonResponse.choices[0].delta) {
                extractedContent = jsonResponse.choices[0].delta.content || '';
              }
            } catch (err) {
              if (!chunk.includes('data:') && chunk.trim()) {
                extractedContent = chunk.trim();
              } else {
                const lines = chunk.split('\n').filter(line => line.trim());

                for (const line of lines) {
                  if (line.startsWith('data: ')) {
                    try {
                      const data = line.slice(6);
                      if (data === '[DONE]') continue;

                      const parsedData = JSON.parse(data);
                      if (parsedData.content) {
                        extractedContent += parsedData.content;
                      } else if (parsedData.response) {
                        extractedContent += parsedData.response;
                      }
                    } catch (parseError) {
                      const content = line.slice(6).trim();
                      if (content && content !== '[DONE]') {
                        extractedContent += content;
                      }
                    }
                  } else if (line.trim() && !line.includes('[DONE]')) {
                    extractedContent += line.trim();
                  }
                }
              }
            }

            if (extractedContent) {
              fullMessage += extractedContent;
              controller.enqueue(`data: ${JSON.stringify({ content: extractedContent })}\n\n`);
              console.log('📤 Chunk enviado a ChatView:', extractedContent);
            }
          }

          controller.enqueue('data: [DONE]\n\n');
          controller.close();
        } catch (e) {
          console.error('🚨 Error en el stream:', e);
          controller.enqueue(`data: ${JSON.stringify({ content: "Error en la comunicación. Por favor, intenta nuevamente." })}\n\n`);
          controller.enqueue('data: [DONE]\n\n');
          controller.close();
        }
      },
    });

    return new Response(streamResponse, {
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      },
    });
  } catch (error) {
    console.error('💥 Error general:', error);
    return NextResponse.json({ error: error?.toString() || 'Error inesperado' }, { status: 500 });
  }
}
