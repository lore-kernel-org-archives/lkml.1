Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbXJBNhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbXJBNhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXJBNg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:36:59 -0400
Received: from mx12.go2.pl ([193.17.41.142]:47926 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112AbXJBNg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:36:59 -0400
Date: Tue, 2 Oct 2007 15:39:29 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071002133929.GA3100@ff.dom.local>
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local> <20071001162507.GA22791@elte.hu> <20071002090346.GA1738@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002090346.GA1738@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 11:03:46AM +0200, Jarek Poplawski wrote:
...
> should suffice. Currently, I wonder if simply charging (with a key
> recalculated) such a task for all the time it could've used isn't one
> of such methods. It seems, it's functionally analogous with going to
> the end of que of tasks with the same priority according to the old
> sched.

Only now I've read I repeat the idea of David Schwartz (and probably
not only him) from a nearby thread, sorry. But, I still try to find
what was wrong with it?

Jarek P.
