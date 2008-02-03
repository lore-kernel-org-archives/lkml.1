Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYBCQuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYBCQuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 11:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYBCQur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 11:50:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:44665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYBCQuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 11:50:46 -0500
Date: Sun, 3 Feb 2008 17:50:44 +0100
From: Karsten Keil <kkeil@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 0/5] isdn: fix section mismatch warnings in isdn
Message-ID: <20080203165044.GB19851@pingi.kke.suse.de>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	isdn4linux@listserv.isdn4linux.de
References: <20080201133838.GA13349@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 02:38:38PM +0100, Sam Ravnborg wrote:
> drivers/isdn resulted in 34 section mismatch warnings - so
> I decided to give them a try.
> This resulted in 5 simple patches.
> 
> I know Jeff Garzik has some ISDN clean-up patches pending
> but rather than waiting forever to have them acked I deciced
> to fix the warnings in the current kernel.
> 
> This for no other reason than to get the noise level down.
> 
> Andrew - I expect you to pick them up in -mm and forward to Linus.
> 

Yes these fixes should go in, Acked.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
