Return-Path: <linux-kernel-owner+w=401wt.eu-S1762358AbXH0QUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762358AbXH0QUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761077AbXH0QNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:13:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:33492 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761062AbXH0QNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:13:23 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <20070827160916.GF4121@stusta.de>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <46D29C3D.5070801@garzik.org>  <20070827160916.GF4121@stusta.de>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 09:05:39 -0700
Message-Id: <1188230739.2435.213.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 18:09 +0200, Adrian Bunk wrote:
> On Mon, Aug 27, 2007 at 05:41:17AM -0400, Jeff Garzik wrote:
> > Andrew Morton wrote:
> >> What I'm concerned about is that regressions which we didn't fix are just
> >> getting lost.  Is anyone taking care to ensure that they are getting
> >> transitioned into bugzilla for tracking?
> >
> > Maybe this was a dumb assumption on my part, but I thought regressions were 
> > getting rolled over into the next release's list, if they are not solved?
> 
> Judging from the regression lists and the regression reports we get 
> post-release both on lkml and in the kernel Bugzilla we have much more 
> than 100 unfixed regressions since 2.6.20 (plus regressions from older 
> kernels...).
> 
> Tracking that many regressions is one problem (although getting all bug 
> reports in Bugzilla would make this quite easy), but the bigger problem 
> is how to get them debugged and resolved.

Maximize the shame right? Post summaries of the regressions to LKML so
that everyone knows about the regression list, and what was broken and
who broke it .. 

Daniel

