Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXCMGRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXCMGRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXCMGRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:17:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:34497 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753148AbXCMGRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:17:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+q8DF8N+yqLJqnnEBgZBLOBp2EN3/kEP8tbJNOQ9
	4kPJcXyncXtSW7
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703131653.39415.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
	 <1173762639.7944.45.camel@Homer.simpson.net>
	 <200703131653.39415.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 07:17:25 +0100
Message-Id: <1173766645.10004.2.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 16:53 +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 16:10, Mike Galbraith wrote:

> > I'm not trying to be pig-headed.  I'm of the opinion that fairness is
> > great... until you strictly enforce it wrt interactive tasks.
> 
> How about answering my question then since I offered you numerous combinations 
> of ways to tackle the problem? The simplest one doesn't even need code, it 
> just needs you to alter the nice value that you're already setting.

Hey, you specifically asked me to not choose 5 :)  (I mentioned 5
earlier in the thread anyway, so no sense in repeating myself)

	-Mike

