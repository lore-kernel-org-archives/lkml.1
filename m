Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbYBTAHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbYBTAHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYBTAHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:07:01 -0500
Received: from www.tglx.de ([62.245.132.106]:45392 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYBTAHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:07:01 -0500
Date: Wed, 20 Feb 2008 01:06:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 updates
In-Reply-To: <20080219155653.4e6bc958.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.00.0802200105320.7583@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802192357550.7583@apollo.tec.linutronix.de> <20080219155653.4e6bc958.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Randy Dunlap wrote:

> On Wed, 20 Feb 2008 00:13:13 +0100 (CET) Thomas Gleixner wrote:
> 
> > Linus,
> > 
> > please pull x86 updates from:
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git master
> > 
> > The major part of this pull are sparse fixes, section fixups,
> > documentation updates and cleanups.
> 
> 
> Hi,
> What happened to the kernel-doc x86/cpu/mtrr patch, which you applied,
> according to your email reply...

It's still applied, is queued in the next batch.

Thanks,

	tglx
