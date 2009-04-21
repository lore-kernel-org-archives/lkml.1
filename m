Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZDUPG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZDUPG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZDUPGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:06:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZDUPGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:06:20 -0400
Date: Tue, 21 Apr 2009 07:44:42 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: Use to_delayed_work
Message-ID: <20090421144442.GA27580@suse.de>
References: <20090403174649.42626ae6@hyperion.delvare> <20090421110752.160ddfb0@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421110752.160ddfb0@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 11:07:52AM +0200, Jean Delvare wrote:
> On Fri, 3 Apr 2009 17:46:49 +0200, Jean Delvare wrote:
> > Use the recently added to_delayed_work() helper function.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  drivers/staging/rtl8187se/r8180_dm.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Greg, can you please add this patch to your staging tree? Thanks.

Yes, sorry, too much "real work" these days, my patch queue is needing a
lot of work...

greg k-h
