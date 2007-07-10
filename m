Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbXGJJSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbXGJJSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbXGJJSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:18:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39029 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757101AbXGJJSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:18:01 -0400
Date: Tue, 10 Jul 2007 02:17:58 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dinakar Guniguntala <dino@in.ibm.com>,
       Cliff Wickman <cpw@sgi.com>
Subject: Re: cpuset-remove-sched-domain-hooks-from-cpusets
Message-Id: <20070710021758.61442677.pj@sgi.com>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> cpuset-remove-sched-domain-hooks-from-cpusets.patch
> 
>  Stuck.

Well ... a few hours ago I just finished the 'unrelated task' that kept
me from doing much cpuset work the last six months.

So, after a little bit of saved up vacation (SGI sabbatical - yippee!),
I should be able to dig into this, see what Dinikar and Cliff have been
up to here, and make some progress on this.  Cliff -- did I see some
work from you go by relating to cpusets and the sched domain hooks in
cpusets?

As before, Andrew, if you're getting bored holding this patch, it's ok
to drop it, even though I still figure you'll see it again, as part of
a patch set to improve this cpuset to sched domain interaction.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
