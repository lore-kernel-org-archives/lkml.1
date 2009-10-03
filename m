Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZJCUUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZJCUUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 16:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZJCUUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 16:20:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58348 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZJCUUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 16:20:42 -0400
Date: Sat, 3 Oct 2009 22:19:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20091003201959.GA16047@elf.ucw.cz>
References: <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com> <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com> <20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org> <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com> <20090930065448.GB11652@elf.ucw.cz> <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-03 01:02:52, Wang, Shane wrote:
> > So I modify the RAM content so that BIOS does not think measured
> > environment existed before suspend?
> > 									Pavel
> 
> Hi Pavel, what do you mean on this question? 
> When do you modify the RAM? before S3 sleep?

During the sleep, using something cold and second machine.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
