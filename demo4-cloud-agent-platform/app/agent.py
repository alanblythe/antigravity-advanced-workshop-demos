import os
import asyncio
from google.adk.agents import Agent
from google.adk.tools.mcp import McpToolset

def create_telemetry_agent() -> Agent:
    """
    Builds the production BigQuery Telemetry Reasoning Engine.
    Bundles the local Database MCP Toolbox via stdio subprocess.
    """
    # Wire Database MCP Toolbox into ADK
    mcp_tools = McpToolset.from_stdio_command(
        command="/usr/local/bin/toolbox",
        args=["--tools-file", "/workspace/tools.yaml", "--stdio"]
    )

    agent = Agent(
        name="bq-telemetry-agent",
        model="gemini-2.5-pro",
        description="Enterprise BigQuery Telemetry Analysis Agent. Inspects schemas and diagnoses query latency anomalies.",
        instruction="""
        You are the enterprise BigQuery Telemetry Agent deployed on Gemini Enterprise Agent Platform.
        Use the bundled Database MCP Toolbox tools to query telemetry data safely.
        Always explain your diagnostic reasoning and provide recommended remediations.
        """,
        tools=[mcp_tools]
    )
    return agent

if __name__ == "__main__":
    agent = create_telemetry_agent()
    # In production GEAP container runtime, ADK handles A2A discovery & HTTP routing
    print(f"✔ Initialized {agent.name} with model {agent.model}")
