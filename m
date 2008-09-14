Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYINLl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYINLl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYINLlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:41:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4953 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752544AbYINLlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:41:20 -0400
Date: Sun, 14 Sep 2008 13:22:22 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080914112222.GA3956@ucw.cz>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-09-12 23:19:21, Thomas Gleixner wrote:
> On Fri, 12 Sep 2008, Andi Kleen wrote:
> > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> > >
> > > to see how wrong could be set by BIOS.
> > 
> > Just dump it from user space then.  There are plenty of tools
> > to access ACPI tables.
> 
> 1.) what guarantees that we reach user space ?

We can dump in *any* kernel.

> 2) If it is _valuable_ information which we can gather via kernel
>    output, then it is much more conveniant than asking the user to type
>    whatevercryptictoolcommandline and provide the output.

Ooh, 'lets dump more junk at everyone, typing commands is hard' :-(.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
