Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXJMKLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXJMKLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 06:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXJMKLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 06:11:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:33945 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753230AbXJMKLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 06:11:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/sGDwa6h/sqISDSMVVjN0w9ig3Y4mVx0b5C7z/po
	CN3niAjBqtIk5D
Subject: Re: [PATCH] sched: high-res preemption tick
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192267072.5897.5.camel@lappy>
References: <1192222309.5897.3.camel@lappy>
	 <1192259938.7369.4.camel@Homer.simpson.net>
	 <1192265717.27435.44.camel@twins>  <1192267072.5897.5.camel@lappy>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 12:11:09 +0200
Message-Id: <1192270269.7221.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 11:17 +0200, Peter Zijlstra wrote:

> Also, this seems to suggest iperf would like SCHED_BATCH.

Yes.  Throughput falls as preemption climbs.

	-Mike

