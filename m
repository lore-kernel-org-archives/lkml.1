Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZFNMfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZFNMfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZFNMew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:34:52 -0400
Received: from www.tglx.de ([62.245.132.106]:56961 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758809AbZFNMev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:34:51 -0400
Date: Sun, 14 Jun 2009 14:34:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
In-Reply-To: <20090614112802.GA4502@kroah.com>
Message-ID: <alpine.LFD.2.00.0906141432540.2800@localhost.localdomain>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1506487989-1244982886=:2800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1506487989-1244982886=:2800
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 14 Jun 2009, Greg KH wrote:

> On Sat, Jun 13, 2009 at 11:38:38PM +0200, Uwe Kleine-König wrote:
> > I know that at least COMEDI and RT2870 are broken with -rt,
> 
> I didn't know this, has anyone sent me a bug report?  What in -rt causes
> these drivers to break?
> 
> > but Thomas requested disabling all of staging.  He's the maintainer.
> 
> This seems like a patch to ensure that the staging drivers never get a
> chance to be fixed for any potential -rt issues.  How about just sending
> me bug reports instead?

Sorry, my bad. But at least the patch now brought your attention on
it. I provide you an useful bugreport in the next days.

Thanks,

	tglx
--8323328-1506487989-1244982886=:2800--
