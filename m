Return-Path: <linux-kernel-owner+w=401wt.eu-S965647AbXCLLXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647AbXCLLXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965662AbXCLLXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:23:35 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:57951 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965647AbXCLLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:23:33 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Mon, 12 Mar 2007 22:23:06 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173697024.8014.19.camel@Homer.simpson.net> <20070312110833.GA12835@elte.hu>
In-Reply-To: <20070312110833.GA12835@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122223.07048.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 22:08, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> > The test scenario was one any desktop user might do with every
> > expectation responsiveness of the interactive application remain
> > intact. I understand the concepts here Con, and I'm not knocking your
> > scheduler. I find it to be a step forward on the one hand, but a step
> > backward on the other.
>
> ok, then that step backward needs to be fixed.
>
> > > We are getting good interactive response with a fair scheduler yet
> > > you seem intent on overloading it to find fault with it.
> >
> > I'm not trying to find fault, I'm TESTING AND REPORTING.  Was.
>
> Con, could you please take Mike's report of this regression seriously
> and address it? Thanks,

Sure. 

Mike the cpu is being proportioned out perfectly according to fairness as I 
mentioned in the prior email, yet X is getting the lower latency scheduling. 
I'm not sure within the bounds of fairness what more would you have happen to 
your liking with this test case?

-- 
-ck
