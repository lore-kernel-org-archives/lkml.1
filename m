Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151Ab0A0L17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0A0L17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669Ab0A0L15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:27:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0A0L14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:27:56 -0500
Date: Wed, 27 Jan 2010 12:24:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Dean Nelson <dnelson@redhat.com>,
       Russ Anderson <rja@sgi.com>, ozan@pardus.org.tr,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
       Gene Heskett <gene.heskett@verizon.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Hounschell <markh@compro.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       David Rientjes <rientjes@google.com>,
       Haicheng Li <haicheng.li@linux.intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.33-rc6
Message-ID: <20100127112446.GA19613@elte.hu>
References: <201001270833.o0R8X7ZN018729@terminus.zytor.com>
 <alpine.LFD.2.00.1001270249190.24253@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001270249190.24253@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 27 Jan 2010, H. Peter Anvin wrote:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/x86/linux-2.6-tip.git x86-fixes-for-linus
> 
> That doesn't work for me at all.

i think Peter typoed it and the git/ portion went missing, it should have 
been:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus

> I assume you meant
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> 
> (note the "git/tip" instead of "x86")

Yes, that works too. The x86 repo is symlinked to the tip repo.

	Ingo
