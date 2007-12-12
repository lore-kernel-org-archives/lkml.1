Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXLLAYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXLLAYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXLLAYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:24:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbXLLAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:24:14 -0500
Date: Tue, 11 Dec 2007 16:24:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: recalljeffchang@gmail.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH acs_ame scsi driver 000 of 1] Introduction
Message-Id: <20071211162408.54544ec3.akpm@linux-foundation.org>
In-Reply-To: <20071210165548.GC26334@parisc-linux.org>
References: <87d84fba0712092003h3eb90344o89f9b0bc9c65fdb7@mail.gmail.com>
	<20071210165548.GC26334@parisc-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 09:55:48 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Dec 10, 2007 at 12:03:18PM +0800, chang jeff wrote:
> > Dear Sir,
> > 
> > Following is patche for scsi driver in 2.6.23.9 what should get into
> > 2.6.23.9-final if possible.
> > 
> > First refines a newly created scsi driver
> > (/[kernel-version]/driver/scsi/acs_ame).
> > 
> > Thanks,
> > JeffChang.
> 
> Hi Jeff,
> 
> You don't seem to have attached the driver ... maybe you sent a second
> email that hasn't arrived yet?  I see Andrew sent a mail (possibly to
> one of your colleagues?) that explains that he doesn't personally take
> scsi driver patches: http://lkml.org/lkml/2007/8/30/7
> 

Well, I'll pass an eye over them and will queue them up for a bit or
review-and-test if it looks like they're being neglected.

However I can't queue this one because a) it's wordwrapped and b) there are
patches in -mm which remove scsi_cmnd.request_buffer (and probably other
things).

But that doesn't prevent scsi developers from performing code review.
