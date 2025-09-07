import asyncio
import websockets

async def echo(websocket):
    async for message in websocket:
        print("📩 Received from client:", message)  # 2. 受信メッセージをログ表示

        # 3秒待ってから返信
        await asyncio.sleep(3)
        response = "Hello from server 👋"
        await websocket.send(response)

async def main():
    async with websockets.serve(echo, "0.0.0.0", 8765):
        print("✅ WebSocket server started at ws://0.0.0.0:8765")
        await asyncio.Future()  # run forever

if __name__ == "__main__":
    asyncio.run(main())

if __name__ == "__main__":
    main()
