Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZIJNx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZIJNx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 09:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZIJNx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 09:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZIJNx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 09:53:57 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Steven Rostedt <srostedt@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090910094433.GA18599@kernel.dk>
References: <1252423398.7746.97.camel@twins>
	 <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk>
	 <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop>
	 <20090910065856.GL18599@kernel.dk> <20090910070443.GC29009@elte.hu>
	 <20090910094433.GA18599@kernel.dk>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 10 Sep 2009 09:53:42 -0400
Message-Id: <1252590822.2964.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 11:44 +0200, Jens Axboe wrote:
> On Thu, Sep 10 2009, Ingo Molnar wrote:

> trace.txt attached. Steven, you seem to go through a lot of trouble to
> find the debugfs path, yet at the very end do:
> 
> > 	system("cat /debug/tracing/trace");
> 
> which doesn't seem quite right :-)
> 

That's an older version of the tool. The newer version (still in alpha)
doesn't do that.

-- Steve


