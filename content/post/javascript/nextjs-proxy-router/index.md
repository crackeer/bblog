---
title: NextJS-API代理后端请求
date: 2025-02-25
slug: nextjs-proxy-router
categories:
  - javascript
  - nextjs
---

# router.js文件内容

> app/api/[service]/[...url]/route.js

```js

import axios from 'axios'
import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

async function handleRequest(request, params) {
    let slug = await params.params;
    const cookieStore = await cookies()
    let envKey = 'API_' + slug.service.toUpperCase();
    if (!process.env[envKey]) {
        return Response.json({
            code: -90,
            message: 'service not found'
        });
    }
    let fullUrl = process.env[envKey] + '/' + slug.url.join('/');
    let header = {}
    if (cookieStore.get('admin-token') != null) {
        header['admin-token'] = cookieStore.get('admin-token')
    }
    if (cookieStore.get('test-admin-token') != null) {
        header['test-admin-token'] = cookieStore.get('test-admin-token')
    }
    header['Content-Type'] = request.headers.get('Content-Type')
    let config = {
        url: fullUrl,
        method: request.method,
        params: null,
        data: null,
        withCredentials: false,
        headers: header,
    }

    if (request.method.toLocaleUpperCase() == "GET") {
        config.params = request.nextUrl.searchParams
    }

    if (request.method.toLocaleUpperCase() == "POST") {
        if (request.headers.get('Content-Type') == 'application/x-www-form-urlencoded') {
            config.data = await request.formData()
        } else if (request.headers.get('Content-Type') == 'application/json') {
            config.data = await request.json()
        }
    }

    let result = await axios(config)
    if (result.data.code == -100) {
        redirect(result.data.data.login_url)
    }

    return Response.json(result.data)
}

export async function GET(request, params) {
    return handleRequest(request, params);
}

export async function POST(request, params) {
    return handleRequest(request, params);
}

```