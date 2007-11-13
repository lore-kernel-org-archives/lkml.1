Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbXKMMCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbXKMMCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbXKMMCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:02:32 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33896 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752250AbXKMMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:02:31 -0500
Date: Tue, 13 Nov 2007 13:02:08 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge: Keep kernel/cpu for CPU specific code?
Message-ID: <20071113120208.GC4250@stusta.de>
References: <20071113114443.GG18993@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071113114443.GG18993@erda.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 12:44:43PM +0100, Robert Richter wrote:
> x86 CPU specific code is currently implemented in different ways for
> 64 and 32 bit. While there are almost no CPU specific files for 64
> bit, there is the arch/x86/kernel/cpu/ directory for 32 bit. Is there
> already an idea about whether to use kernel/cpu also for 64 bit?

It is also used for 64bit for years.

> Thanks,
> 
> -Robert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

