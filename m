Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZFWHSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZFWHSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZFWHSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:18:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZFWHSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:18:22 -0400
Date: Tue, 23 Jun 2009 09:18:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: +
	printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
	added to -mm tree
Message-ID: <20090623071817.GA5747@elte.hu>
References: <200906230556.n5N5uG3a017246@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906230556.n5N5uG3a017246@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      printk boot_delay: rename printk_delay_msec to loops_per_msec
> has been added to the -mm tree.  Its filename is
>      printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: printk boot_delay: rename printk_delay_msec to loops_per_msec
> From: Dave Young <hidave.darkstar@gmail.com>
> 
> Rename `printk_delay_msec' to `loops_per_msec', because the patch "printk:
> add printk_delay to make messages readable for some scenarios" wishes to
> more appropriately use the `printk_delay_msec' identifier.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

For all 3 patches:

  Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
