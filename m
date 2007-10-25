Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbXJYPqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbXJYPqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbXJYPpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:45:55 -0400
Received: from xenotime.net ([66.160.160.81]:35527 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758638AbXJYPpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:45:54 -0400
Date: Thu, 25 Oct 2007 08:45:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Message-Id: <20071025084551.71fa6cd4.rdunlap@xenotime.net>
In-Reply-To: <20071025105652.GB10536@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	<20071024080451.GA32690@infradead.org>
	<20071024110733.GA1374@uranus.ravnborg.org>
	<20071024121218.GA23548@elte.hu>
	<20071024213052.GA5469@uranus.ravnborg.org>
	<20071024155043.04ba31cd.rdunlap@xenotime.net>
	<86802c440710242314i6e16b544g1e10f7af0f917cf9@mail.gmail.com>
	<20071025105652.GB10536@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 12:56:52 +0200 Sam Ravnborg wrote:

> > ...
> > in x86_64/Kconfig has EARLY_PRINTK too
> > 
> > config EARLY_PRINTK
> >         bool
> >         default y
> 
> I noticed this too. So on x86_64 it was unconditionally enabled
> whereas with i386 (and the merged files) if it an option that
> can be turned off.
> 
> Randy - did you realise this when you did the merge?

No, I missed that.

---
~Randy
