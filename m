Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYELHPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYELHPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYELHOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:14:54 -0400
Received: from www.tglx.de ([62.245.132.106]:53658 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYELHOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:14:53 -0400
Date: Mon, 12 May 2008 09:14:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug #10615] Oops with strace_test
In-Reply-To: <88YBFoyd1CN.A.sAB.3w1JIB@chimera>
Message-ID: <alpine.LFD.1.10.0805120912070.3514@apollo.tec.linutronix.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.sAB.3w1JIB@chimera>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10615
> Subject		: Oops with strace_test
> Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> Date		: 2008-04-30 14:12 (12 days old)
> References	: http://lkml.org/lkml/2008/4/30/162
> Handled-By	: Suresh Siddha <suresh.b.siddha@intel.com>
> Patch		: http://lkml.org/lkml/2008/5/7/225

fixes by: fd3c3ed5d1e3ceb37635cbe6d220ab94aae0781d

Thanks,
	tglx
