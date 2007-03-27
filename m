Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbXC0FkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbXC0FkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933986AbXC0FkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:40:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:17304 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbXC0FkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:40:08 -0400
X-IronPort-AV: i="4.14,331,1170651600"; 
   d="scan'208"; a="25577719:sNHT23660161"
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "Wu, Bryan" <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070326222711.d2f42da2.randy.dunlap@oracle.com>
References: <1174903941.32691.72.camel@roc-desktop>
	 <200703262345.09489.arnd@arndb.de> <1174966837.6966.13.camel@roc-desktop>
	 <20070327035734.GA25883@linux-sh.org>
	 <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
	 <20070327044914.GA26099@linux-sh.org>
	 <8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com>
	 <20070326222711.d2f42da2.randy.dunlap@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 27 Mar 2007 13:40:45 +0800
Message-Id: <1174974045.6966.26.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 27 Mar 2007 05:40:06.0932 (UTC) FILETIME=[60477540:01C77032]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 22:27 -0700, Randy Dunlap wrote:
> On Tue, 27 Mar 2007 01:17:06 -0400 Mike Frysinger wrote:
> 
> > On 3/27/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > > On Tue, Mar 27, 2007 at 12:34:25AM -0400, Mike Frysinger wrote:
> > > > On 3/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > > > >You should really consider the latter for getting updates merged in the
> > > > >future
> > > >
> > > > we're planning for this, but the short term it isnt doable for us
> > >
> > > If you think mangling patches by hand is a more effective use of time, no
> > > one is stopping you -- some people even prefer that. On the other hand, if
> > > you're struggling with an effective methodology before things are merged,
> > > what reason is there to suspect that things will get better afterwards?
> > 
> > we have a lot of infrastructure that the SCM is part of and at the
> > moment, git is not a supported SCM
> > 
> > i'm not saying the current system is easy, just that we cant integrate
> > git in the short term, so we'll continue spanking Bryan with the
> > overhead :/
> 
> In that case, Bryan may like to know that git, mercurial (IIRC),
> and quilt have patchbomb tools.  Also GregKH has one somewhere (he
> can tell you where).  And Paul Jacksone has one at
>   http://www.speakeasy.org/~pj99/sgi/sendpatchset
> 

Thanks for this guide line information. I will dig into it.

But in my experience, it is difficult to find right patch email
receivers, even in the MAINTAINERS file. If there are 20 patch emails,
we should find 20 email receivers at least and manually add them to the
emails. This is terrible, right? Any idea?

Best Regards,
-Bryan
