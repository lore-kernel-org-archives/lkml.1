Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZIZJ4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZIZJ4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 05:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZIZJ4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 05:56:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZIZJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:56:34 -0400
Date: Sat, 26 Sep 2009 11:56:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Joseph Cihula <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20090926095631.GH1331@ucw.cz>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909142051.n8EKpiOM017912@terminus.zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-txt-for-linus
> 
> Arnaldo Carvalho de Melo (1):
>       x86, intel_txt: Fix typos in Kconfig help
> 
> H. Peter Anvin (3):
>       x86, intel_txt: Factor out the code for S3 setup
>       x86, intel_txt: Handle ACPI_SLEEP without X86_TRAMPOLINE

This went in despite my NAK/request for more info. It seems you are
simply ignoring feedback you don't like :-(

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
