Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZBEWzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZBEWzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZBEWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:55:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZBEWy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:54:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
Date: Thu, 5 Feb 2009 23:54:15 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.o-D.uuYiJB@chimera> <Pine.LNX.4.64.0902051723520.1445@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902051723520.1445@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902052354.16361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Hugh Dickins wrote:
> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
> > Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2009-01-23 23:52 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
> > 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> > Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> > 		  Hugh Dickins <hugh@veritas.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=123254501314058&w=2
> 
> Yes, this does still need to be listed.  My initial patch for it was
> not enough, but I think the three patches necessary have all now been
> posted (though Sergei may rewrite mine).  I'm expecting Alan to gather
> them together and send them in due course, but I believe he's occupied
> with other stuff just at the moment.

Thanks for the update.

Rafael
