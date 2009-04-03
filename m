Return-Path: <linux-kernel-owner+w=401wt.eu-S936193AbZDCUPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936193AbZDCUPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761065AbZDCUOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:14:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbZDCUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:14:54 -0400
Date: Fri, 3 Apr 2009 16:14:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 2/2] ftrace: Clean up enable logic for sched_switch
In-Reply-To: <49D1C596.5050203@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904031614310.21481@gandalf.stny.rr.com>
References: <49D1C51C.7000407@cn.fujitsu.com> <49D1C596.5050203@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 31 Mar 2009, Zhaolei wrote:

> Unify sched_switch and sched_wakeup's action to following logic:
> Do record_cmdline when start_cmdline_record() called.
> Trace event when trace is inited and started.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Thanks, applied.

-- Steve

