Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbXGRLJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbXGRLJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbXGRLJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:09:41 -0400
Received: from box.memset.com ([89.200.136.113]:55514 "EHLO box.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXGRLJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:09:41 -0400
To: linux-kernel@vger.kernel.org
Cc: Zan Lynx <zlynx@acm.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <8IdHQ-7Pm-23@gated-at.bofh.it>
References: <8IdHQ-7Pm-25@gated-at.bofh.it> <8IdHQ-7Pm-27@gated-at.bofh.it> <8IdHQ-7Pm-29@gated-at.bofh.it> <8IdHQ-7Pm-31@gated-at.bofh.it> <8IdHQ-7Pm-33@gated-at.bofh.it> <8IdHQ-7Pm-35@gated-at.bofh.it> <8IdHQ-7Pm-37@gated-at.bofh.it> <8IdHQ-7Pm-39@gated-at.bofh.it> <8IdHQ-7Pm-41@gated-at.bofh.it> <8IdHQ-7Pm-43@gated-at.bofh.it> <8IdHQ-7Pm-45@gated-at.bofh.it> <8IdHQ-7Pm-47@gated-at.bofh.it> <8IdHQ-7Pm-49@gated-at.bofh.it> <8IdHQ-7Pm-23@gated-at.bofh.it>
Date: Wed, 18 Jul 2007 12:09:38 +0100
Message-Id: <20070718110938.587151074197@irishsea.home.craig-wood.com>
From: nick@craig-wood.com (Nick Craig-Wood)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Craig-Wood <nick@craig-wood.com> wrote:
>  Zan Lynx <zlynx@acm.org> wrote:
> >  There *are* crashes from LVM and ext3.  I had to change kernels to avoid
> >  them.
> > 
> >  I had crashes with ext3 on LVM snapshot on DM mirror on SATA.
> 
>  We've noticed these too... ext3/LVM/raid0/sata seems fine.  If you add
>  snapshot in that mix then it becomes rather unreliable.

I meant raid1 up there not raid0!

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
