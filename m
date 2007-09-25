Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbXIYGLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbXIYGLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXIYGLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:11:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:37454 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751293AbXIYGLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:11:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+3cBAMeY63tHyvtewLWIWpySr1yf3gC4Ts4WjngP
	CMx0v9Uj0e1zeo
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070924214537.GA18980@elte.hu>
References: <20070924214537.GA18980@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 08:10:52 +0200
Message-Id: <1190700652.6482.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 23:45 +0200, Ingo Molnar wrote:

> Mike Galbraith (2):
>       sched: fix SMP migration latencies
>       sched: fix formatting of /proc/sched_debug

Off-by-one bug in attribution, rocks and sticks (down boy!) don't
count ;-)  I just built, and will spend the morning beating on it... no
news is good news.

	-Mike

