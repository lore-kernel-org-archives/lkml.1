Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZDYNEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZDYNEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 09:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZDYNEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 09:04:36 -0400
Received: from www.tglx.de ([62.245.132.106]:44330 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZDYNEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 09:04:35 -0400
Date: Sat, 25 Apr 2009 15:04:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: tom smith <tsmithtree@gmail.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel Panic: Early exception with 2.6.29.1-rt8 on x86_64
In-Reply-To: <e743c9de0904200044j1f71310ar122c8ea1fdcd2649@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904251503410.4529@localhost.localdomain>
References: <e743c9de0904200044j1f71310ar122c8ea1fdcd2649@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom,

On Mon, 20 Apr 2009, tom smith wrote:

> Hi, I'm using kernel 2.6.29.1 without the rt patch and it works fine,
> but with the rt8 patch I recieve a kernel panic immediately after the
> bootloader. Both were using the same configuration with the exception
> of the realtime preemption options. I previously used 2.6.26.8-rt16
> iirc and it worked fine, with the same configuration as well. early
> printk is enabled. I have uploaded my .config, lspci, dmesg from a
> working kernel, and the crash output from the kernel.
> http://www.persuasiveigloo.com/linux/ Thanks for reading, if you think
> any other outputs/configs would be helpful to debug this issue I will
> gladly upload them. please cc me as I am off list for linux-kernel

Can you please test 2.6.29.1-rt9. It has a fix for this. Thanks for
providing detailed information to debug this issue.

Thanks,

	tglx
