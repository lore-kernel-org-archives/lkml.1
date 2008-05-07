Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbYEGDwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbYEGDwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYEGDwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:52:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752465AbYEGDwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:52:32 -0400
Date: Tue, 6 May 2008 22:52:28 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, maxk@qualcomm.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       rientjes@google.com
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch (was: Fix
 cpuset sched_relax_domain_level control file)
Message-Id: <20080506225228.d42630cf.pj@sgi.com>
In-Reply-To: <20080506204444.f4c38d0a.akpm@linux-foundation.org>
References: <48210101.1070205@google.com>
	<20080506183138.546f42d9.akpm@linux-foundation.org>
	<20080506204054.564fff32.pj@sgi.com>
	<20080506223859.0b4fa876.pj@sgi.com>
	<20080506204444.f4c38d0a.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> Don't worry about it.  I sorted out things locally and I expect that
> Stephen will be able to as well.

Ok ...

I hesitate more than I should some times to NAQ patches,
but the more I think about this one, the less willing I
am to have a per-cpuset file called "system".

I'm not sure what "sorted out" means ... I'll wait and see.

Thanks, Andrew.

Sorry, Max, Peter and Ingo ... we really had not arrived at
agreement on this one.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
