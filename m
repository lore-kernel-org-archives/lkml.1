Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZDUBVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZDUBVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZDUBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:20:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39630 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZDUBUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:20:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090420171107.GA5974@nowhere>
References: <49E82CA7.2040606@cn.fujitsu.com> <20090420171107.GA5974@nowhere>
Message-Id: <20090421102036.F110.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 10:20:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 17, 2009 at 03:15:51PM +0800, Zhaolei wrote:
> > v3: zhaolei@cn.fujitsu.com: Change TRACE_EVENT definition to new format
> >     introduced by Steven Rostedt: consolidate trace and trace_event headers
> > v2: kosaki@jp.fujitsu.com: print the function names instead of addr, and zap
> >     the work addr
> 
> Kosaki-san, may I add you Signed-off-by on this one?
> Since you participated in this patch.
> 
> Thanks.

Sure! thanks.




