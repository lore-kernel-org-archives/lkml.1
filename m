Return-Path: <linux-kernel-owner+w=401wt.eu-S1765680AbXHGUVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765680AbXHGUVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXHGUVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:21:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbXHGUVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:21:01 -0400
Date: Tue, 7 Aug 2007 13:19:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
Message-Id: <20070807131949.fa060048.akpm@linux-foundation.org>
In-Reply-To: <1186179369.13852.36.camel@localhost>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	<1186179369.13852.36.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 15:16:09 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2007-08-03 at 17:05 +0200, Jean Delvare wrote: 
> > Fine with me, but this first patch should still be correct per se.
> 
> Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
> pr_info and pr_debug are unchanged
> Remove local pr_err #defines
> Convert current uses of pr_err

OK, I've lost the plot here.  If we have now converged on an
agreeable patch, please resend it?
