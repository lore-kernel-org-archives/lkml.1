Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbXJQEUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbXJQEUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 00:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXJQEUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 00:20:38 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:58146 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbXJQEUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 00:20:36 -0400
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI updates for 2.6.24
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1192421381.3429.6.camel@localhost.localdomain>
References: <1192421381.3429.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017132026D.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 17 Oct 2007 13:20:26 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 00:09:41 -0400
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> This is the accumulated updates queued for 2.6.24.  It contains the
> usual slew of driver updates, plus some gdth and advansys rewrites.  We
> still have some outstanding bugs in gdth and fc4 for which I'm hoping to
> sweep fixes into the next update.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> The short changelog is:

(snip)

> James Bottomley (4):
>       Fix device not ready printk
>       sg: use idr to replace static arrays
>       move ULD attachment into the prep function
>       arcmsr: fix compile problems

The patch to beautify supported_mode and active_mode in sysfs?

http://marc.info/?l=linux-kernel&m=119077857701415&w=2
