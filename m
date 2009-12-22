Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZLVNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZLVNWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZLVNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:22:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbZLVNWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:22:35 -0500
Message-ID: <4B30C7AE.3090304@cn.fujitsu.com>
Date: Tue, 22 Dec 2009 21:20:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5]: trace_event: export HZ in timer's tracepoint
 format
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com>
In-Reply-To: <4B30C3A0.909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, sorry for this title error. :-(

s/[PATCH v2 2/5]:/[PATCH v2 2/5]

Xiao Guangrong wrote:
> Export HZ in timer's tracepoint, we can use it to get
> TIMER/ITIMER_VIRTUAL/ITIMER_PROF exact latency and it's
> suggested by Ingo
> 
