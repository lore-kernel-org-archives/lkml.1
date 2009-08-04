Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbZHDQxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbZHDQxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbZHDQxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:53:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918AbZHDQxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:53:41 -0400
Message-ID: <4A786802.5050305@redhat.com>
Date: Tue, 04 Aug 2009 12:55:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, Dave Anderson <anderson@redhat.com>,
       crash-utility@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       srostedt@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
 analyze tracing from core-file (make tracing can act as a flight recorder)
References: <4A76F8A1.30503@cn.fujitsu.com> <1249314136.7924.126.camel@twins> <4A77DA98.6050509@cn.fujitsu.com>
In-Reply-To: <4A77DA98.6050509@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> [
> http://lkml.org/lkml/2009/7/30/30
>
> This patch is really useful for kernel. We don't change the kernel
> even a single line for the purpose of we can read the core-file easier.
>
> This patch is also helpful for crash more or less. So I mention it.
> ]

Hmm, this patch can conflict with my patch.

http://lkml.org/lkml/2009/7/24/234

However, this change seems reasonably good. I'll update
my patch after that is merged.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

