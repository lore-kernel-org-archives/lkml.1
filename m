Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYJ0Ll1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYJ0Ll1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYJ0LlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:41:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58094 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJ0LlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:41:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [Bug #11835] 2.6.27-git8: max1111_read_channel and corgi_ssp_ads7846_putget missing
Date: Mon, 27 Oct 2008 12:46:07 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.xbC.tV5AJB@chimera> <20081027085640.GC30526@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081027085640.GC30526@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271246.08373.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 of October 2008, Pavel Machek wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11835
> > Subject		: 2.6.27-git8: max1111_read_channel and corgi_ssp_ads7846_putget missing
> > Submitter	: Pavel Machek <pavel@suse.cz>
> > Date		: 2008-10-20 12:10 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122450475101945&w=4
> 
> ...seems to be fixed in 2.6.28-rc1. Unfortunately, resulting kernel
> still will not boot :-(.

-rc2 should be better at that. :-)

Thanks,
Rafael
