Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbYEGGpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbYEGGpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbYEGGov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:44:51 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:39996 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756185AbYEGGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:44:50 -0400
X-SourceIP: 80.56.237.116
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch (was: Fix
	cpuset sched_relax_domain_level control file)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, maxk@qualcomm.com, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, rientjes@google.com
In-Reply-To: <20080506225228.d42630cf.pj@sgi.com>
References: <48210101.1070205@google.com>
	 <20080506183138.546f42d9.akpm@linux-foundation.org>
	 <20080506204054.564fff32.pj@sgi.com> <20080506223859.0b4fa876.pj@sgi.com>
	 <20080506204444.f4c38d0a.akpm@linux-foundation.org>
	 <20080506225228.d42630cf.pj@sgi.com>
Content-Type: text/plain
Date: Wed, 07 May 2008 08:44:41 +0200
Message-Id: <1210142681.13978.166.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 22:52 -0500, Paul Jackson wrote:
> Andrew wrote:
> > Don't worry about it.  I sorted out things locally and I expect that
> > Stephen will be able to as well.
> 
> Ok ...
> 
> I hesitate more than I should some times to NAQ patches,
> but the more I think about this one, the less willing I
> am to have a per-cpuset file called "system".
> 
> I'm not sure what "sorted out" means ... I'll wait and see.
> 
> Thanks, Andrew.
> 
> Sorry, Max, Peter and Ingo ... we really had not arrived at
> agreement on this one.

No problem, I've been meaning to redo this whole series but somehow
stuff got in the way and I never got around to it :-/


