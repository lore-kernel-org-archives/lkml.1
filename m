Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXFZQEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXFZQEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFZQD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:03:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36925 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXFZQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:03:57 -0400
Date: Tue, 26 Jun 2007 09:04:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: DervishD <lkml@dervishd.net>
Cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-Id: <20070626090414.835df520.randy.dunlap@oracle.com>
In-Reply-To: <20070626153358.GA27438@DervishD>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
	<20070623104303.a186c5a8.randy.dunlap@oracle.com>
	<pan.2007.06.23.20.24.29@free.fr>
	<20070626101639.GB20178@DervishD>
	<20070626102414.GU27862@lug-owl.de>
	<20070626153358.GA27438@DervishD>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 17:33:59 +0200 DervishD wrote:

>     Hi Jan :)
> 
>  * Jan-Benedict Glaw <jbglaw@lug-owl.de> dixit:
> > On Tue, 2007-06-26 12:16:39 +0200, DervishD <lkml@dervishd.net> wrote:
> > >     Given that it happens too with "ldd", it really *is* that hard. I
> > > don't know why still people think that /bin/sh is always /bin/bash. If
> > > they want/need bash, that's ok to me, I will have it installed for such
> > > tasks, but they should call it "#!/bin/bash".
> > 
> > ...or "#!/usr/bin/env bash" for what it's worth...  The same for plain
> > `sh'.
> 
>     The "env" solution is a bit of a problem, too. Not always "env" is
> installed in /usr/bin, but in /bin, so it is available even if /usr is
> not still mounted. But /bin/sh is pretty standard (as it should be
> /bin/bash, anyway), and it's only two chars shorter than the correct
> "/bin/bash". No idea why it is not fixed.

because nobody sent a patch yet?

but I'll get around tuit.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
