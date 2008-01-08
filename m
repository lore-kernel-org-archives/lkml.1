Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYAHK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYAHK6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYAHK6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:58:10 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:55764 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbYAHK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:58:07 -0500
Date: Tue, 8 Jan 2008 16:27:33 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
Message-ID: <20080108105733.GA2569@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080106161128.152634000@chello.nl> <1199703080.7143.24.camel@twins> <20080107122330.GB25945@linux.vnet.ibm.com> <1199725063.31975.53.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199725063.31975.53.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 05:57:42PM +0100, Peter Zijlstra wrote:
> 
> Subject: sched: rt-group: add uid-group interface
> 
> Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> the group's rt_period and rt_runtime.
> 

Hi Peter,

Cool stuff! I will try out these patches and try to give you some
feedback.

One request though, could you please add some documentation to
Documentation/ABI/testing/sysfs-kernel-uids?

Thanks,
-- 
regards,
Dhaval
