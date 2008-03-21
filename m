Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYCUQwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYCUQwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYCUQwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:52:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbYCUQwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:52:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: 2.6.25-rc4-git3: Reported regressions from 2.6.24
Date: Fri, 21 Mar 2008 17:52:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>
References: <200803100132.57160.rjw@sisk.pl> <200803122339.32662.rjw@sisk.pl> <1206066612.14496.80.camel@ymzhang>
In-Reply-To: <1206066612.14496.80.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803211752.03974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Zhang, Yanmin wrote:
> On Wed, 2008-03-12 at 23:39 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, 12 of March 2008, Zhang, Yanmin wrote:
> > > On Mon, 2008-03-10 at 01:32 +0100, Rafael J. Wysocki wrote:
> > > > [Due to the lack of time for reviewing all of the email threads related to the
> > > > regressions marked as "unresolved" below, I might have missed some patches
> > > > fixing them.  If you are involved in debugging/fixing any of them, please let
> > > > me know if I should update the list.  Thanks!]
> > > > 
> > > > This message contains a list of some regressions from 2.6.24 reported since
> > > > 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> > > > of.  If any of them have been fixed already, please let me know.
> > > > 
> > > > If you know of any other unresolved regressions from 2.6.24, please let me know
> > > > either and I'll add them to the list.  Also, please let me know if any of the
> > > > entries below are invalid.
> > > > 
> > > > 
> > > > Listed regressions statistics:
> > > > 
> > > >   Date          Total  Pending  Unresolved
> > > >   ----------------------------------------
> > > >   2008-03-10      138       66          47
> > > >   2008-03-03      115       65          49
> > > >   2008-02-25       90       51          39
> > > >   2008-02-17       61       45          37
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10013
> > > > Subject		: tbench regression in 2.6.25-rc1
> > > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > > Date		: 2008-02-15 02:52
> > > > References	: http://lkml.org/lkml/2008/2/14/546
> > > > Handled-By	: Eric Dumazet <dada1@cosmosbay.com>
> > > > 		  David Miller <davem@davemloft.net>
> > > > Patch		: http://lkml.org/lkml/2008/2/18/66
> > > > 		  http://lkml.org/lkml/2008/2/18/117
> > > > 
> > > The latest patch is http://lkml.org/lkml/2008/2/20/83. 2.6.25-rc5 doesn't
> > > include it. tbench regression still exists on my tigerton machine.
> > 
> > I updated the entry with this information.
> 2.6.25-rc6 includes the latest patch and I tested 2.6.25-rc6 on my 16-core tigerton. The
> issue is fixed. Pls. close the bug report.

Adrian has already closed it.

Thanks,
Rafael
