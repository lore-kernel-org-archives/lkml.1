Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbXGOQYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbXGOQYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbXGOQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:24:09 -0400
Received: from xenotime.net ([66.160.160.81]:47150 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759110AbXGOQYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:24:07 -0400
Date: Sun, 15 Jul 2007 09:28:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       leoli@freescale.com, Gerrit Huizenga <gh@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, gregkh@suse.de, pavel@ucw.cz,
       tim.bird@am.sony.com, arjan@infradead.org, sam@ravnborg.org,
       jengelh@computergmbh.de, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
Subject: Re: Documentation of kernel messages (Summary)
Message-Id: <20070715092806.d15d1156.rdunlap@xenotime.net>
In-Reply-To: <200707142156.16139.rob@landley.net>
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com>
	<200707131405.50143.rob@landley.net>
	<20070713205441.28967ac3.rdunlap@xenotime.net>
	<200707142156.16139.rob@landley.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 21:56:15 -0400 Rob Landley wrote:

> On Friday 13 July 2007 11:54:41 pm Randy Dunlap wrote:
> > > If there's interest, I can push some patches to clean up Documentation by
> > > moving files into subdirectories, but Documentation's not well-suited to
> > > link out to the web.  (You need html for that, and it's text.)
> >
> > I think that you should start moving Documentation/ files around
> > and adding subdirectories -- if you are pretty sure of where they
> > should go (i.e., they won't likely be moved again later on).
> 
> You mean like these?
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2925.html
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2924.html

Yes.  Have any of these been merged?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
