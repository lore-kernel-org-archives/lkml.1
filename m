Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZDMAxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZDMAxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 20:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZDMAxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 20:53:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61921 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDMAxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 20:53:41 -0400
Message-ID: <49E28D00.2020803@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 08:53:20 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] tracing, workqueuetrace: Make workqueue tracepoints use
 TRACE_EVENT macro
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I moved workqueue trace to use TRACE_EVENT macro.

CC: Frederic Weisbecker
I see in your mail that you will scheduled to do it, but that time I already
finished it. (I haven't send it to ltml that time because it need apply on top
of my previous patch which was send but not commited)
So I just send this patch, you can accept it, or drop it and use yours if is
is not good.

Thanks
Zhaolei

