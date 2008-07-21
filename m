Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYGUUza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYGUUza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYGUUzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:55:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31309 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbYGUUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:55:00 -0400
Date: Mon, 21 Jul 2008 13:53:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: Michael Buesch <mb@bu3sch.de>, gregkh <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Message-Id: <20080721135332.4ce02e0c.randy.dunlap@oracle.com>
In-Reply-To: <200807211341.35766.david-b@pacbell.net>
References: <200807182201.33913.mb@bu3sch.de>
	<20080718151037.a54dec8a.randy.dunlap@oracle.com>
	<200807211341.35766.david-b@pacbell.net>
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

On Mon, 21 Jul 2008 13:41:35 -0700 David Brownell wrote:

> [ I see "v3" switches to configfs ... same comments apply. ]


> > > Index: linux-next/Documentation/gpiommc.txt
> > > ===================================================================
> > > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > > +++ linux-next/Documentation/gpiommc.txt	2008-07-18 21:54:05.000000000 +0200
> 
> Should there be a  Documentation/mmc/... for such stuff, instead?

What other files could be moved into that subdir?

> The toplevel Documentation directory is getting unmanageable.

Yes, it is.



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
