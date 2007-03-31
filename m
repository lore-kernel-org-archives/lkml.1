Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbXCaGbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbXCaGbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXCaGbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:31:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:51949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751185AbXCaGbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:31:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18wv74X2Zkwn4incSWXkjVlojJJgjC19eEE5AOP8w
	CDkfSajaObDoup
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <834572.46808.qm@web26713.mail.ukl.yahoo.com>
References: <834572.46808.qm@web26713.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 08:31:46 +0200
Message-Id: <1175322706.6030.20.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 22:41 -0700, Xenofon Antidides wrote:

> Patch makes X yuck with any load. I stick with SD.

Shrug.  My milage is different, but hey, it's a work in progress.  If SD
ever gets to the point that it actually delivers what it claims, I may
join you.

In the meantime, IMHO mainline is MUCH better in the general case.  If
the general case was that which the various sleep exploits do, the
history mechanism in mainline wouldn't have survived it's first day.

	-Mike

