Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbZGJFOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbZGJFOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZGJFOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:14:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59153 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZGJFOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:14:40 -0400
Message-ID: <4A56CE3C.6060500@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 13:14:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: Use the %pf format
References: <1247107590-6428-1-git-send-email-fweisbec@gmail.com> <1247107590-6428-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1247107590-6428-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Remove the obsolete seq_print_ip_sym() usage and replace it
> by the %pf format in order to print function symbols.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/trace/trace_functions_graph.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
