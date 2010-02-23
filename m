Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0BWNrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:47:18 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58023 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0BWNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:47:16 -0500
Message-ID: <4B83DC61.2030409@dcl.info.waseda.ac.jp>
Date: Tue, 23 Feb 2010 22:47:13 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf sched broken on tip, bisected
References: <20100222190042.GB15854@ghostprotocols.net> <20100222190952.GD15854@ghostprotocols.net>
In-Reply-To: <20100222190952.GD15854@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年02月23日 04:09, Arnaldo Carvalho de Melo wrote:
> While testing a patch series I'm working on I noticed that 'perf sched record ;
> perf sched latency' is broken on tip, bisected it down to this cset, investigating...
>

Very sorry, Arnaldo...
I'll fix it later.

	Hitoshi
