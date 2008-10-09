Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYJIQVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYJIQVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYJIQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:21:22 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46820 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbYJIQVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:21:20 -0400
Date: Thu, 9 Oct 2008 19:21:19 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: panic while doing lots of IO on lpfc
In-Reply-To: <200810101233.18726.nickpiggin@yahoo.com.au>
Message-ID: <Pine.SOC.4.64.0810091919260.5106@math.ut.ee>
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee>
 <200810101233.18726.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tried to lock a free page. Is the address of the page always the same,
> and the first bit in flags always set after each reboot? Does the
> machine pass a memtest?

No, the machine does not pass memtest :(
Thanks for the reminder.

So please ignore this thread - if I find any errors with good RAM, I 
will open a new thread.

-- 
Meelis Roos (mroos@linux.ee)
