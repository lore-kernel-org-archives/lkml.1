Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbYBJN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYBJN7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYBJN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:59:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54135 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYBJN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:59:21 -0500
Date: Sun, 10 Feb 2008 13:58:52 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: scsi/arm/fas216.c compile error
Message-ID: <20080210135851.GB25703@flint.arm.linux.org.uk>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi> <47AEF6FD.8080801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AEF6FD.8080801@panasas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 03:07:09PM +0200, Boaz Harrosh wrote:
> It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
>   [SCSI] arm: convert to accessors and !use_sg cleanup
> 
> Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
> to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
> we finally managed a Tested-by:.
> 
> I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
> schedule.

Oh, I was ill for most of December, particularly at the time that you
sent the patch, and by the time I recovered, it was buried in my mailbox.

Suggest you have some consideration for others who might not be able to
do your beg and call at the immediate moment that you want it, and
consider that their email management skills may not be as l33t as yours.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
