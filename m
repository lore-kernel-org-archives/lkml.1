Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZFAU3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZFAU3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZFAU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:29:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbZFAU3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:29:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13362] [mac80211 ] Wifi Network Slownes Bisected
Date: Mon, 1 Jun 2009 22:29:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Alejandro Riveira =?iso-8859-2?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "John W. Linville" <linville@tuxdriver.com>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <20090531003941.4891c859@varda> <1243764096.19302.34.camel@johannes.local>
In-Reply-To: <1243764096.19302.34.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906012229.31088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009, Johannes Berg wrote:
> On Sun, 2009-05-31 at 00:39 +0200, Alejandro Riveira Fernández wrote:
> > El Sat, 30 May 2009 21:37:34 +0200 (CEST)
> > "Rafael J. Wysocki" <rjw@sisk.pl> escribió:
> > 
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.29.  Please verify if it still should be listed and let me know
> > > (either way).
> > 
> >  It should be listed.
> 
> But it should definitely be retitled -- the commit bisect pointed out
> has little to do with the problem. And Handled-by should point to Ivo
> since he was asking for debugging info and stuff.
> 
> Retitle to "rt2x00: slow wifi with correct basic rate bitmap" or
> something like that, it's not a bug in mac80211.

Done.

Best,
Rafael
