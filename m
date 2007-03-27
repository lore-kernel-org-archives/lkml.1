Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbXC0Fbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbXC0Fbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXC0Fbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:31:48 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:19384 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbXC0Fbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:31:47 -0400
X-IronPort-AV: i="4.14,331,1170651600"; 
   d="scan'208"; a="25577336:sNHT24197999"
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com>
References: <1174903941.32691.72.camel@roc-desktop>
	 <200703262345.09489.arnd@arndb.de> <1174966837.6966.13.camel@roc-desktop>
	 <20070327035734.GA25883@linux-sh.org>
	 <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
	 <20070327044914.GA26099@linux-sh.org>
	 <8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 27 Mar 2007 13:32:24 +0800
Message-Id: <1174973545.6966.19.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 27 Mar 2007 05:31:46.0485 (UTC) FILETIME=[35FD4E50:01C77031]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 01:17 -0400, Mike Frysinger wrote:
> On 3/27/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Tue, Mar 27, 2007 at 12:34:25AM -0400, Mike Frysinger wrote:
> > > On 3/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > > >You should really consider the latter for getting updates merged in the
> > > >future
> > >
> > > we're planning for this, but the short term it isnt doable for us
> >
> > If you think mangling patches by hand is a more effective use of time, no
> > one is stopping you -- some people even prefer that. On the other hand, if
> > you're struggling with an effective methodology before things are merged,
> > what reason is there to suspect that things will get better afterwards?
> 
> we have a lot of infrastructure that the SCM is part of and at the
> moment, git is not a supported SCM
> 

I hope git will one of it. You know, with git kernel development will be
much easier.

> i'm not saying the current system is easy, just that we cant integrate
> git in the short term, so we'll continue spanking Bryan with the
> overhead :/

Cool, That's my duty. 
-Bryan
