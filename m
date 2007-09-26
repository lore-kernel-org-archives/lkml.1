Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXIZKsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXIZKsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXIZKsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:48:33 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1876 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbXIZKsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:48:32 -0400
Date: Wed, 26 Sep 2007 12:48:14 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926104814.GM3337@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190802208.7318.5.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2007-09-26 12:23]:
> I noticed on the iperf website a patch which contains sched_yield().
> http://dast.nlanr.net/Projects/Iperf2.0/patch-iperf-linux-2.6.21.txt
> 
> Do you have that patch applied by any chance?  If so, it might be a
> worth while to try it without it.

Yes, this patch was applied.  When I revert it, I get the same (high)
performance with both kernels.
-- 
Martin Michlmayr
http://www.cyrius.com/
