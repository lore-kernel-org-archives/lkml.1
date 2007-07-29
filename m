Return-Path: <linux-kernel-owner+w=401wt.eu-S936603AbXG2VTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936603AbXG2VTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935648AbXG2VSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:18:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48170 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935497AbXG2VSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:18:48 -0400
Date: Sun, 29 Jul 2007 23:18:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND
Message-ID: <20070729211824.GL16817@stusta.de>
References: <200707251238.50218.lenb@kernel.org> <200707291438.06849.rjw@sisk.pl> <20070729204001.GJ16817@stusta.de> <200707292317.21419.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707292317.21419.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:17:20PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 29 July 2007 22:40, Adrian Bunk wrote:
> > On Sun, Jul 29, 2007 at 02:38:05PM +0200, Rafael J. Wysocki wrote:
> > >...
> > > +config SUSPEND
> > > +	bool "Suspend"
> >              "Suspend to RAM"
> 
> Not only.  This also includes "standby".

Whatever it includes - please tell it to the user in the prompt.

Technical issues are important, but it's often forgotten how many 
problems people run into because the description of a kconfig option 
could have been better.

> > >...
> > >  config HIBERNATION
> > >  	bool "Hibernation"
> > >...         "Hibernation (Suspend to disk)"
> > 
> > cu
> > Adrian
> 
> Greetings,
> Rafael
> 
> 
> -- 
> "Premature optimization is the root of all evil." - Donald Knuth

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

