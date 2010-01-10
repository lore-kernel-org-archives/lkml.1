Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535Ab0AJXRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0AJXRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424Ab0AJXRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:17:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:40137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0AJXRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:17:52 -0500
Date: Sun, 10 Jan 2010 15:20:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
Message-ID: <20100110152037.1d59d7cd@infradead.org>
In-Reply-To: <CXIfLt-ygXM.A.XRD.NilSLB@chimera>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	<CXIfLt-ygXM.A.XRD.NilSLB@chimera>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 23:56:13 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
> Subject		: perf subsystem breakage in 2.6.32-rc7
> Submitter	: Arjan van de Ven <arjan@infradead.org>
> Date		: 2009-11-19 19:50 (53 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=125866013419738&w=4


patch available in the bugzilla, and also in
http://patchwork.kernel.org/patch/71962/

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
