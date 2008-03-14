Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYCNTHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYCNTHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYCNTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:07:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYCNTHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:07:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Date: Fri, 14 Mar 2008 20:06:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803120141.51844.rjw@sisk.pl> <20080314184245.GA7151@ucw.cz>
In-Reply-To: <20080314184245.GA7151@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803142006.35771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of March 2008, Pavel Machek wrote:
> On Wed 2008-03-12 01:41:51, Rafael J. Wysocki wrote:
> > [Again, some entries have been closed since yesterday and there's been some
> > regressions-related activity in general, so below is yet another update.
> > It contains a new feature too: the "approximate age" of each regression
> > report.]
> > 
> > This message contains a list of some regressions from 2.6.24 reported since
> > 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> > 
> > If you know of any other unresolved regressions from 2.6.24, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> > 
> > 
> > Listed regressions statistics:
> > 
> >   Date          Total  Pending  Unresolved
> >   ----------------------------------------
> >   2008-03-12      143       51          41
> >   2008-03-11      141       58          43
> >   2008-03-10      138       66          47
> >   2008-03-03      115       65          49
> >   2008-02-25       90       51          39
> >   2008-02-17       61       45          37
> > 
> > 
> > Unresolved regressions
> > ----------------------
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9954
> > Subject		: iwl3945: not only it periodically dies, it also BUG()s
> > Submitter	: Pavel Machek <pavel@ucw.cz>
> > Date		: 2008-02-05 22:44 (37 days old)
> > References	: http://lkml.org/lkml/2008/2/5/453
> > Handled-By	: Chatre, Reinette <reinette.chatre@intel.com>
> 
> I only seen the BUG() once. iwl3945 seems to work slightly better, big
> part of problem was CGROUP_SCHED... All problems with iwl are not
> solved, but it probably works as well as it did in 2.6.24 now...

Thanks for the update, I've closed the bug.

Rafael
