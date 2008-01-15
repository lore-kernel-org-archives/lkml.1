Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYAORAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYAORAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYAORAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:00:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYAORAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:00:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.24-rc7-git4: Reported regressions from 2.6.23
Date: Tue, 15 Jan 2008 18:03:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Kristoffer =?iso-8859-15?q?Malmstr=F6m?= <malmis@malmis.com>
References: <200801122205.34871.rjw@sisk.pl> <478CDA7F.30207@trash.net>
In-Reply-To: <478CDA7F.30207@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801151803.06655.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 of January 2008, Patrick McHardy wrote:
> Rafael J. Wysocki wrote:
> > [RFC: Would that be useful if I sent regression-fixing patches, CCed to the
> > appropriate maintainers/lists, along with the reports?]
> > 
> > This message contains a list of some regressions from 2.6.23 reported since
> > 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> > 
> > If you know of any other unresolved regressions from 2.6.23, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> > 
> 
> > Subject		: iptables won't work
> > Submitter	: Kristoffer Malmström <malmis@malmis.com>
> > Date		: 2007-12-28
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9657
> > Handled-By	: Patrick McHardy <kaber@trash.net>
> 
> 
> The reporter has disappeared, so I guess this wasn't a regression
> caused by the kernel but some other mistake.

I'll close it as unreproducibl, then.

Thanks,
Rafael
