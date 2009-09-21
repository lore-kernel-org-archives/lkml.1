Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZIUJaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZIUJaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZIUJaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:30:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZIUJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:30:16 -0400
Date: Mon, 21 Sep 2009 11:30:19 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] trivial: fix typos "enalbe" -> "enable"
Message-ID: <20090921093019.GB26665@pengutronix.de>
References: <1253522362-22856-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LNX.2.00.0909211118340.17028@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.0909211118340.17028@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Mon, Sep 21, 2009 at 11:19:43AM +0200, Jiri Kosina wrote:
> On Mon, 21 Sep 2009, Uwe Kleine-König wrote:
> 
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index aa99fd1..cfd4c91 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -22,6 +22,6 @@ config PAGE_POISONING
> >  	   the patterns before alloc_pages(). This results in a large slowdown,
> >  	   but helps to find certain types of memory corruptions.
> >  
> > -	   This option cannot enalbe with hibernation. Otherwise, it will get
> > +	   This option cannot enable with hibernation. Otherwise, it will get
> >  	   wrong messages for memory corruption because the free pages are not
> >  	   saved to the suspend image.
> 
> This fix is not really correct -- the sentence doesn't have too much sense 
> even after the typo fix.
> Plus, it has been already fixed in a proper way, please see 
> http://git.kernel.org/?p=linux/kernel/git/jikos/trivial.git;a=commitdiff;h=d5dd245f15b243b313df044741c0ba8065b0bc91
ah, OK.

should I repost the remaining hunk or do you do that?

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
