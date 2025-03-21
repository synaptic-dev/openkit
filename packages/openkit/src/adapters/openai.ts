import { OpenAIAdapterOptions } from "../builders/types";
import {
  OpenAIChatCompletionTool,
  OpenAIChatCompletionToolMessageParam,
} from "../types";

/**
 * OpenAI adapter for converting apps to OpenAI function calling format
 */
export class OpenAIAdapter {
  private _apps: any[];

  /**
   * Create a new OpenAI adapter
   * @param options OpenAI adapter options
   */
  constructor(options: OpenAIAdapterOptions) {
    this._apps = options.apps;
  }

  /**
   * Get OpenAI function definitions for all apps
   * @returns Array of OpenAI function definitions
   */
  tools(): OpenAIChatCompletionTool[] {
    // Collect function definitions from all apps
    const allDefinitions: OpenAIChatCompletionTool[] = [];

    for (const app of this._apps) {
      // Each app has its own way to generate OpenAI functions
      if (typeof app.getOpenAIFunctions === "function") {
        const functions = app.getOpenAIFunctions();
        allDefinitions.push(...functions);
      }
    }

    return allDefinitions;
  }

  /**
   * Handle OpenAI tool calls
   * @param options Object containing message or chatCompletion
   * @returns Tool responses for OpenAI
   */
  async handler(options: {
    message?: any;
    chatCompletion?: any;
  }): Promise<OpenAIChatCompletionToolMessageParam[]> {
    // Extract message from either direct message or chat completion
    const message =
      options.message || options.chatCompletion?.choices?.[0]?.message;

    if (!message || !message.tool_calls || !message.tool_calls.length) {
      return [];
    }

    const results: OpenAIChatCompletionToolMessageParam[] = [];

    // Handle each tool call
    for (const toolCall of message.tool_calls) {
      const { id, function: fn } = toolCall;
      const { name, arguments: argsStr } = fn;

      try {
        // Parse arguments
        const args = JSON.parse(argsStr);

        // Find the right app and execute
        let response: any = null;

        // Extract app name prefix from function name
        const appNamePrefix = name.split("-")[0];

        // Find the app that should handle this tool call based on name prefix
        for (const app of this._apps) {
          // Check if this app's name matches the function name prefix
          const appPrefix = app.name.toLowerCase().replace(/\s+/g, "_");
          const isForThisApp = name.startsWith(`${appPrefix}-`);

          if (isForThisApp && typeof app.handleToolCall === "function") {
            // Try to handle with this app
            const handled = await app.handleToolCall(name, args);
            if (handled !== undefined) {
              response = handled;
              break;
            }
          }
        }

        // Create response - ensure content is always a string, never null
        results.push({
          role: "tool",
          tool_call_id: id,
          content: response !== null ? JSON.stringify(response) : "",
        });
      } catch (error) {
        // Handle errors - ensure error message is always a string, never null
        results.push({
          role: "tool",
          tool_call_id: id,
          content: `Error: ${error instanceof Error ? error.message : String(error)}`,
        });
      }
    }

    return results;
  }
}
