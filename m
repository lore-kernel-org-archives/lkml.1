Return-Path: <linux-kernel-owner+w=401wt.eu-S1763858AbXJQMIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763858AbXJQMIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbXJQMIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:08:09 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56613 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbXJQMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:08:07 -0400
Subject: Re: [GIT PATCH] SCSI updates for 2.6.24
From: James Bottomley <James.Bottomley@SteelEye.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071017132026D.fujita.tomonori@lab.ntt.co.jp>
References: <1192421381.3429.6.camel@localhost.localdomain>
	 <20071017132026D.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 08:08:03 -0400
Message-Id: <1192622883.28752.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 13:20 +0900, FUJITA Tomonori wrote:
> On Mon, 15 Oct 2007 00:09:41 -0400
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > This is the accumulated updates queued for 2.6.24.  It contains the
> > usual slew of driver updates, plus some gdth and advansys rewrites.  We
> > still have some outstanding bugs in gdth and fc4 for which I'm hoping to
> > sweep fixes into the next update.
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > 
> > The short changelog is:
> 
> (snip)
> 
> > James Bottomley (4):
> >       Fix device not ready printk
> >       sg: use idr to replace static arrays
> >       move ULD attachment into the prep function
> >       arcmsr: fix compile problems
> 
> The patch to beautify supported_mode and active_mode in sysfs?
> 
> http://marc.info/?l=linux-kernel&m=119077857701415&w=2

Well, I suppose losing your own patches is a sign of fairness in patch
loss ... OK I'll stick them in.

James


