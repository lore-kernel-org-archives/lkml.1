Return-Path: <linux-kernel-owner+w=401wt.eu-S965135AbXGRXrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbXGRXrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937628AbXGRXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:44:47 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:50803 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937532AbXGRXop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:44:45 -0400
To: bzolnier@gmail.com
Cc: tomof@acm.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: block/bsg.c
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200707182239.38293.bzolnier@gmail.com>
References: <200707172252.25729.bzolnier@gmail.com>
	<20070718072644F.tomof@acm.org>
	<200707182239.38293.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070719084434C.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 19 Jul 2007 08:44:34 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 22:39:38 +0200

> 
> On Wednesday 18 July 2007, FUJITA Tomonori wrote:
> 
> > They were fixed. Please check the latest code:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git bsg
> > 
> > We wait for Linus to pull from it.
> 
> It has been merged.  Thanks for fixing the mentioned issues.

You're welcome. Thanks for the ide-floppy fix.
