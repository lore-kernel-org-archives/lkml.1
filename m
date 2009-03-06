Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZCFQus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZCFQus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZCFQuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:50:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZCFQuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:50:39 -0500
Date: Fri, 6 Mar 2009 11:50:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/5 v2] add binary printf
In-Reply-To: <1236356510-8381-2-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0903061149540.23248@gandalf.stny.rr.com>
References: <1236356510-8381-1-git-send-email-fweisbec@gmail.com> <1236356510-8381-2-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Mar 2009, Frederic Weisbecker wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Impact: Add APIs for binary trace printk infrastructure
> 
> vbin_printf(): write args to binary buffer, string is copied
> when "%s" is occurred.
> 
> bstr_printf(): read from binary buffer for args and format a string
> 
> [fweisbec@gmail.com: rebase against latest -tip]
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Well it finally decided to show up.

for the whole series:

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

