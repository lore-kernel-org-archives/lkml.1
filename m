Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727Ab0A0Kwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0A0Kwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903Ab0A0Kws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:52:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab0A0Kws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:52:48 -0500
Date: Wed, 27 Jan 2010 02:50:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dean Nelson <dnelson@redhat.com>, Russ Anderson <rja@sgi.com>,
       ozan@pardus.org.tr, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
       Gene Heskett <gene.heskett@verizon.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Hounschell <markh@compro.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       David Rientjes <rientjes@google.com>,
       Haicheng Li <haicheng.li@linux.intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.33-rc6
In-Reply-To: <201001270833.o0R8X7ZN018729@terminus.zytor.com>
Message-ID: <alpine.LFD.2.00.1001270249190.24253@localhost.localdomain>
References: <201001270833.o0R8X7ZN018729@terminus.zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, H. Peter Anvin wrote:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/x86/linux-2.6-tip.git x86-fixes-for-linus

That doesn't work for me at all.

I assume you meant

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

(note the "git/tip" instead of "x86")

			Linus
