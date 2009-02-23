Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZBWWNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZBWWNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZBWWNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:13:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42025 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZBWWNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:13:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
Date: Mon, 23 Feb 2009 23:13:00 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <200902070058.26539.rjw@sisk.pl> <49A2CD3B.4090703@lwfinger.net>
In-Reply-To: <49A2CD3B.4090703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232313.01391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> > On Saturday 07 February 2009, Larry Finger wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Thursday 05 February 2009, Hugh Dickins wrote:
> >>>> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> >>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
> >>>>> Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
> >>>>> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> >>>>> Date		: 2009-01-23 23:52 (13 days old)
> >>>>> References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
> >>>>> 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> >>>>> Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> >>>>> 		  Hugh Dickins <hugh@veritas.com>
> >>>>> Patch		: http://marc.info/?l=linux-kernel&m=123254501314058&w=2
> >>>> Yes, this does still need to be listed.  My initial patch for it was
> >>>> not enough, but I think the three patches necessary have all now been
> >>>> posted (though Sergei may rewrite mine).  I'm expecting Alan to gather
> >>>> them together and send them in due course, but I believe he's occupied
> >>>> with other stuff just at the moment.
> >> I still have the problem as of 2.6.29-rc3-00634-g9be260a
> > 
> 
> The problem was fixed as of 2.6.29-rc5-00168-gba95fd4 with commit d1b3525. At
> least for my system, the regression is cleared.

It's already been closed, thanks for the confirmation.

Rafael
