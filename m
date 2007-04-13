Return-Path: <linux-kernel-owner+w=401wt.eu-S1030870AbXDMXGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030870AbXDMXGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030873AbXDMXGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:06:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49876 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030869AbXDMXGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:06:32 -0400
Date: Sat, 14 Apr 2007 01:06:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] i386: fix file_read_actor() and pipe_read()  for original i386 systems
Message-ID: <20070413230640.GG5907@stusta.de>
References: <1174810024.10840.477.camel@localhost.localdomain> <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org> <1175516731.28263.129.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1175516731.28263.129.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied to 2.6.16.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

