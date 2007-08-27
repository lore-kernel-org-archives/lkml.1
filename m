Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXH0Qeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXH0Qeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXH0Qeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:34:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46297 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbXH0Qee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:34:34 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <20070827005131.b93f5935.akpm@linux-foundation.org>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 09:26:48 -0700
Message-Id: <1188232008.2435.222.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 00:51 -0700, Andrew Morton wrote:
> On Mon, 27 Aug 2007 02:45:02 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > Daniel Walker pisze:
> > [snip]
> > > Have you considered maintaining all the lists in Bugzilla?
> > 
> > Yes, I have considered it.
> > 
> > Bugzilla sucks when it comes to tracking things. There is
> > a regression field, but there are no difference between
> > 2.6.22 and 2.6.23 regression.
> > 
> > Most people are reporting bugs through LKML:
> > - 23 regressions with reference to LKML
> > - 4 regressions with reference to Bugzilla
> 
> Presumably that's fixable.

I've got some addition grips that I just noticed ..

http://bugzilla.kernel.org/show_bug.cgi?id=8945

I just file the above bugz entry ..

I know who caused the bug , Stephane Eranian <eranian@hpl.hp.com> ..
However I can't assign the bug to him. The field was greyed out and
forced the assignee as other_other@kernel-bugs.osdl.org ..

I tryed to CC: eranian@hpl.hp.com , and it said "no match" .. I guess
because he doesn't have an account.. So Stephane has no way to know the
bug exists , other than me emailing him ..

Also I couldn't check the "Regression" box until after I filed the bug..
It would be nice to file the bug in one action if it's possible .. I
don't know bugzilla well enough to know if that's possible tho.

Daniel

