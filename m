Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086Ab0AKHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0AKHFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 02:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953Ab0AKHFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 02:05:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:54086 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751836Ab0AKHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 02:05:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Liq4yFvFLxn5LPkfDffnqXGjTuhYolhXoodr6jv
	qUiC0eamHK0exa
Subject: Re: [Bug #14621] specjbb2005 and aim7 regression with 2.6.32-rc
 kernels
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <CXIfLt-ygXM.A.DuD.cilSLB@chimera>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <CXIfLt-ygXM.A.DuD.cilSLB@chimera>
Content-Type: text/plain
Date: Mon, 11 Jan 2010 08:05:28 +0100
Message-Id: <1263193528.6444.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 23:56 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14621
> Subject		: specjbb2005 and aim7 regression with 2.6.32-rc kernels
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2009-11-06 7:38 (66 days old)
> References	: http://marc.info/?l=linux-kernel&m=125749310413174&w=4

FWIW, I couldn't reproduce the aim7 regression with my one little disk,
the opposite in fact, attributable to cfq low_latency switch.

(don't have specjbb2005, can't try to reproduce that one)

	-Mike

