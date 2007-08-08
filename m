Return-Path: <linux-kernel-owner+w=401wt.eu-S936715AbXHHUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936715AbXHHUAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763078AbXHHUAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:00:47 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:55770 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755883AbXHHUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:00:47 -0400
Date: Wed, 8 Aug 2007 22:02:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
Message-ID: <20070808220226.1dc03a67@hyperion.delvare>
In-Reply-To: <20070807131949.fa060048.akpm@linux-foundation.org>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	<1186179369.13852.36.camel@localhost>
	<20070807131949.fa060048.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 13:19:49 -0700, Andrew Morton wrote:
> On Fri, 03 Aug 2007 15:16:09 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Fri, 2007-08-03 at 17:05 +0200, Jean Delvare wrote: 
> > > Fine with me, but this first patch should still be correct per se.
> > 
> > Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
> > pr_info and pr_debug are unchanged
> > Remove local pr_err #defines
> > Convert current uses of pr_err
> 
> OK, I've lost the plot here.  If we have now converged on an
> agreeable patch, please resend it?

I don't think we have, no. It's not even clear what Joe is trying to
achieve.

-- 
Jean Delvare
