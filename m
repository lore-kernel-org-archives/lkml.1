Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYGWDLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYGWDLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 23:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYGWDLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 23:11:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18864 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYGWDLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 23:11:02 -0400
Date: Tue, 22 Jul 2008 20:10:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: circumvention and ignorance (was: Re: linux-next:
 Tree for July 22)
Message-Id: <20080722201005.2d1081f5.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0807230140000.28765@anakin>
References: <20080722184059.a58c79d7.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0807230140000.28765@anakin>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 01:49:30 +0200 (CEST) Geert Uytterhoeven wrote:

> 	Hi all,
> 
> Looking at today's http://kisskb.ellerman.id.au/kisskb/matrix/, there's
> plenty of red, and not only in the linux-next division :-(
> 
> On Tue, 22 Jul 2008, Stephen Rothwell wrote:
> > We are up to 105 trees (counting Linus' and 14 trees of patches pending for
> > Linus' tree), more are welcome (even if they are currently empty).
> > Thanks to those who have contributed, and to those who haven't, please do.
> 
> We still see regular merging of trivially breaking patches that
> apparently never have been in linux-next...
> 
> > The ttydev tree was partially merged upstream and gained so many
> > conflicts that I have temporarily dropped it.
> 
> Worse, we're seeing things getting merged that have been known-broken in
> several linux-next incarnations during the last few weeks...
> 
> Now we have such a great thing like linux-next (thanks, Stephen! You
> saved my day a lot lately), perhaps we should start making full use of
> it?

E.g., we don't seem to have a good method of moving build fixes into their
appropriate tree/patchset.  Or maybe it's just that we can't get them
noticed by the appropriate people.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
