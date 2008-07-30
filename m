Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYG3Hqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYG3Hqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYG3Hql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:46:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbYG3Hqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:46:40 -0400
Date: Wed, 30 Jul 2008 00:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RESEND x9+ patch 2.6.26-git 1/2] lm75: cleanup
 and reorg
Message-Id: <20080730004615.f0686916.akpm@linux-foundation.org>
In-Reply-To: <48901BF7.9050601@hhs.nl>
References: <200807251523.28242.david-b@pacbell.net>
	<20080729233231.0ced6d9b.akpm@linux-foundation.org>
	<48901BF7.9050601@hhs.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 09:44:55 +0200 Hans de Goede <j.w.r.degoede@hhs.nl> wrote:

> > > Minor cleanup and reorg of the lm75 code.
> >
> > This patch (and the other) have been in Mark's tree for a month or so. 
> > (linux-next <- useful!)
>  >
> > Mark has been pretty, umm, low-key lately.  I've attached the full
> > git-hwmon changelog below and the authors of all those changes are
> > cc'ed.
> >
> > Could people please confirm that what is in linux-next is still the
> > latest and greatest version of their changes?  If so, I shall plan on
> > fishing those changes out of there and getting them into -rc2.
> 
> Andrew,
> 
> I see that atleast this patch:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-July/023629.html
> 
> Is missing which is a minor yet somewhat important bugfix to the abituguru3 
> driver, see:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-July/023630.html
> 
> For my: "Acked-by: Hans de Goede <j.w.r.degoede at hhs.nl>" Line (I'm the 
> maintainer of that driver).
> 
> It would be nice if this fix could make 2.6.27.
> 

OK.  Can you please email me any patches which you think should be in
2.6.27 in the usual manner, with the appropriate mailing list cc's?  Add
your own signed-off-by: if needed.  I'll get it all lined up.

Or Jean can do it if he'd prefer - the main thing is to not let
people's reviewed, tested and merged code fall out of 2.6.27.

> 
> Also Jean has been doing a lot of patches for all i2c hwmon driver to convert 
> them to new style driver binding, and I've reviewed and Acked the entire bunch.
> So all in all it looks like we're dropping patches, does anyone know whats up 
> with Mark, holiday or ... ?

He did mention a while ago that he had little time, but I don't know
whether that is a temporary state.

