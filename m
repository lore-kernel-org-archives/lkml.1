Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0BUWMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:12:14 -0500
Received: from www.tglx.de ([62.245.132.106]:58415 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab0BUWMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:12:08 -0500
Date: Sun, 21 Feb 2010 23:11:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
In-Reply-To: <wj3ZQZlk_KB.A.KuC.fwagLB@chimera>
Message-ID: <alpine.LFD.2.00.1002212310030.2811@localhost.localdomain>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera> <wj3ZQZlk_KB.A.KuC.fwagLB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
> Subject		: perf subsystem breakage in 2.6.32-rc7
> Submitter	: Arjan van de Ven <arjan@infradead.org>
> Date		: 2009-11-19 19:50 (95 days old)
> References	: http://marc.info/?l=linux-kernel&m=125866013419738&w=4

Can we please take that off the list? That bisect result is more than
silly and we never got any useful information about that "problem".

Thanks,

	tglx

